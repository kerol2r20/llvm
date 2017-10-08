//===-- BPFAsmParser.cpp - Parse BPF assembly to MCInst instructions --===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/BPFMCTargetDesc.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCParser/MCAsmLexer.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

namespace {
struct BPFOperand;

class BPFAsmParser : public MCTargetAsmParser {
  SMLoc getLoc() const { return getParser().getTok().getLoc(); }

  bool PreMatchCheck(OperandVector &Operands);

  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;

  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;

  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;

  bool ParseDirective(AsmToken DirectiveID) override;

  // "=" is used as assignment operator for assembly statment, so can't be used
  // for symbol assignment.
  bool equalIsAsmAssignment() override { return false; }
  // "*" is used for dereferencing memory that it will be the start of
  // statement.
  bool starIsStartOfStatement() override { return true; }

#define GET_ASSEMBLER_HEADER
#include "BPFGenAsmMatcher.inc"

  OperandMatchResultTy parseImmediate(OperandVector &Operands);
  OperandMatchResultTy parseRegister(OperandVector &Operands);
  OperandMatchResultTy parseOperandAsOperator(OperandVector &Operands);

public:
  enum BPFMatchResultTy {
    Match_Dummy = FIRST_TARGET_MATCH_RESULT_TY,
#define GET_OPERAND_DIAGNOSTIC_TYPES
#include "BPFGenAsmMatcher.inc"
#undef GET_OPERAND_DIAGNOSTIC_TYPES
  };

  BPFAsmParser(const MCSubtargetInfo &STI, MCAsmParser &Parser,
               const MCInstrInfo &MII, const MCTargetOptions &Options)
      : MCTargetAsmParser(Options, STI) {
    setAvailableFeatures(ComputeAvailableFeatures(STI.getFeatureBits()));
  }
};

/// BPFOperand - Instances of this class represent a parsed machine
/// instruction
struct BPFOperand : public MCParsedAsmOperand {

  enum KindTy {
    Token,
    Register,
    Immediate,
  } Kind;

  struct RegOp {
    unsigned RegNum;
  };

  struct ImmOp {
    const MCExpr *Val;
  };

  SMLoc StartLoc, EndLoc;
  union {
    StringRef Tok;
    RegOp Reg;
    ImmOp Imm;
  };

  BPFOperand(KindTy K) : MCParsedAsmOperand(), Kind(K) {}

public:
  BPFOperand(const BPFOperand &o) : MCParsedAsmOperand() {
    Kind = o.Kind;
    StartLoc = o.StartLoc;
    EndLoc = o.EndLoc;

    switch (Kind) {
    case Register:
      Reg = o.Reg;
      break;
    case Immediate:
      Imm = o.Imm;
      break;
    case Token:
      Tok = o.Tok;
      break;
    }
  }

  bool isToken() const override { return Kind == Token; }
  bool isReg() const override { return Kind == Register; }
  bool isImm() const override { return Kind == Immediate; }
  bool isMem() const override { return false; }

  bool isConstantImm() const {
    return isImm() && dyn_cast<MCConstantExpr>(getImm());
  }

  int64_t getConstantImm() const {
    const MCExpr *Val = getImm();
    return static_cast<const MCConstantExpr *>(Val)->getValue();
  }

  bool isSImm12() const {
    return (isConstantImm() && isInt<12>(getConstantImm()));
  }

  /// getStartLoc - Gets location of the first token of this operand
  SMLoc getStartLoc() const override { return StartLoc; }
  /// getEndLoc - Gets location of the last token of this operand
  SMLoc getEndLoc() const override { return EndLoc; }

  unsigned getReg() const override {
    assert(Kind == Register && "Invalid type access!");
    return Reg.RegNum;
  }

  const MCExpr *getImm() const {
    assert(Kind == Immediate && "Invalid type access!");
    return Imm.Val;
  }

  StringRef getToken() const {
    assert(Kind == Token && "Invalid type access!");
    return Tok;
  }

  void print(raw_ostream &OS) const override {
    switch (Kind) {
    case Immediate:
      OS << *getImm();
      break;
    case Register:
      OS << "<register x";
      OS << getReg() << ">";
      break;
    case Token:
      OS << "'" << getToken() << "'";
      break;
    }
  }

  void addExpr(MCInst &Inst, const MCExpr *Expr) const {
    assert(Expr && "Expr shouldn't be null!");

    if (auto *CE = dyn_cast<MCConstantExpr>(Expr))
      Inst.addOperand(MCOperand::createImm(CE->getValue()));
    else
      Inst.addOperand(MCOperand::createExpr(Expr));
  }

  // Used by the TableGen Code
  void addRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands!");
    Inst.addOperand(MCOperand::createReg(getReg()));
  }

  void addImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands!");
    addExpr(Inst, getImm());
  }

  static std::unique_ptr<BPFOperand> createToken(StringRef Str, SMLoc S) {
    auto Op = make_unique<BPFOperand>(Token);
    Op->Tok = Str;
    Op->StartLoc = S;
    Op->EndLoc = S;
    return Op;
  }

  static std::unique_ptr<BPFOperand> createReg(unsigned RegNo, SMLoc S,
                                               SMLoc E) {
    auto Op = make_unique<BPFOperand>(Register);
    Op->Reg.RegNum = RegNo;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  static std::unique_ptr<BPFOperand> createImm(const MCExpr *Val, SMLoc S,
                                               SMLoc E) {
    auto Op = make_unique<BPFOperand>(Immediate);
    Op->Imm.Val = Val;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  // Identifiers that can be used at the start of a statment.
  static bool isValidIdAtStart(StringRef Name) {
    return StringSwitch<bool>(Name.lower())
        .Case("if", true)
        .Case("call", true)
        .Case("goto", true)
        .Case("*", true)
        .Case("exit", true)
        .Case("lock", true)
        .Case("ld_pseudo", true)
        .Default(false);
  }

  // Identifiers that can be used in the middle of a statment.
  static bool isValidIdInMiddle(StringRef Name) {
    return StringSwitch<bool>(Name.lower())
        .Case("u64", true)
        .Case("u32", true)
        .Case("u16", true)
        .Case("u8", true)
        .Case("be64", true)
        .Case("be32", true)
        .Case("be16", true)
        .Case("le64", true)
        .Case("le32", true)
        .Case("le16", true)
        .Case("goto", true)
        .Case("ll", true)
        .Case("skb", true)
        .Case("s", true)
        .Default(false);
  }
};
} // end anonymous namespace.

#define GET_REGISTER_MATCHER
#define GET_MATCHER_IMPLEMENTATION
#include "BPFGenAsmMatcher.inc"

bool BPFAsmParser::PreMatchCheck(OperandVector &Operands) {

  if (Operands.size() == 4) {
    // check "reg1 = -reg2" and "reg1 = be16/be32/be64/le16/le32/le64 reg2",
    // reg1 must be the same as reg2
    BPFOperand &Op0 = (BPFOperand &)*Operands[0];
    BPFOperand &Op1 = (BPFOperand &)*Operands[1];
    BPFOperand &Op2 = (BPFOperand &)*Operands[2];
    BPFOperand &Op3 = (BPFOperand &)*Operands[3];
    if (Op0.isReg() && Op1.isToken() && Op2.isToken() && Op3.isReg()
        && Op1.getToken() == "="
        && (Op2.getToken() == "-" || Op2.getToken() == "be16"
            || Op2.getToken() == "be32" || Op2.getToken() == "be64"
            || Op2.getToken() == "le16" || Op2.getToken() == "le32"
            || Op2.getToken() == "le64")
        && Op0.getReg() != Op3.getReg())
      return true;
  }

  return false;
}

bool BPFAsmParser::MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                                           OperandVector &Operands,
                                           MCStreamer &Out, uint64_t &ErrorInfo,
                                           bool MatchingInlineAsm) {
  MCInst Inst;
  SMLoc ErrorLoc;

  if (PreMatchCheck(Operands))
    return Error(IDLoc, "additional inst constraint not met");

  switch (MatchInstructionImpl(Operands, Inst, ErrorInfo, MatchingInlineAsm)) {
  default:
    break;
  case Match_Success:
    Inst.setLoc(IDLoc);
    Out.EmitInstruction(Inst, getSTI());
    return false;
  case Match_MissingFeature:
    return Error(IDLoc, "instruction use requires an option to be enabled");
  case Match_MnemonicFail:
    return Error(IDLoc, "unrecognized instruction mnemonic");
  case Match_InvalidOperand:
    ErrorLoc = IDLoc;

    if (ErrorInfo != ~0U) {
      if (ErrorInfo >= Operands.size())
        return Error(ErrorLoc, "too few operands for instruction");

      ErrorLoc = ((BPFOperand &)*Operands[ErrorInfo]).getStartLoc();

      if (ErrorLoc == SMLoc())
        ErrorLoc = IDLoc;
    }

    return Error(ErrorLoc, "invalid operand for instruction");
  }

  llvm_unreachable("Unknown match type detected!");
}

bool BPFAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                 SMLoc &EndLoc) {
  const AsmToken &Tok = getParser().getTok();
  StartLoc = Tok.getLoc();
  EndLoc = Tok.getEndLoc();
  RegNo = 0;
  StringRef Name = getLexer().getTok().getIdentifier();

  if (!MatchRegisterName(Name)) {
    getParser().Lex(); // Eat identifier token.
    return false;
  }

  return Error(StartLoc, "invalid register name");
}

OperandMatchResultTy
BPFAsmParser::parseOperandAsOperator(OperandVector &Operands) {
  SMLoc S = getLoc();

  if (getLexer().getKind() == AsmToken::Identifier) {
    StringRef Name = getLexer().getTok().getIdentifier();

    if (BPFOperand::isValidIdInMiddle(Name)) {
      getLexer().Lex();
      Operands.push_back(BPFOperand::createToken(Name, S));
      return MatchOperand_Success;
    }

    return MatchOperand_NoMatch;
  }

  switch (getLexer().getKind()) {
  case AsmToken::Minus:
  case AsmToken::Plus: {
    if (getLexer().peekTok().is(AsmToken::Integer))
      return MatchOperand_NoMatch;
  }
  // Fall through.

  case AsmToken::Equal:
  case AsmToken::Greater:
  case AsmToken::Less:
  case AsmToken::Pipe:
  case AsmToken::Star:
  case AsmToken::LParen:
  case AsmToken::RParen:
  case AsmToken::LBrac:
  case AsmToken::RBrac:
  case AsmToken::Slash:
  case AsmToken::Amp:
  case AsmToken::Percent:
  case AsmToken::Caret: {
    StringRef Name = getLexer().getTok().getString();
    getLexer().Lex();
    Operands.push_back(BPFOperand::createToken(Name, S));

    return MatchOperand_Success;
  }

  case AsmToken::EqualEqual:
  case AsmToken::ExclaimEqual:
  case AsmToken::GreaterEqual:
  case AsmToken::GreaterGreater:
  case AsmToken::LessEqual:
  case AsmToken::LessLess: {
    Operands.push_back(BPFOperand::createToken(
        getLexer().getTok().getString().substr(0, 1), S));
    Operands.push_back(BPFOperand::createToken(
        getLexer().getTok().getString().substr(1, 1), S));
    getLexer().Lex();

    return MatchOperand_Success;
  }

  default:
    break;
  }

  return MatchOperand_NoMatch;
}

OperandMatchResultTy BPFAsmParser::parseRegister(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);

  switch (getLexer().getKind()) {
  default:
    return MatchOperand_NoMatch;
  case AsmToken::Identifier:
    StringRef Name = getLexer().getTok().getIdentifier();
    unsigned RegNo = MatchRegisterName(Name);

    if (RegNo == 0)
      return MatchOperand_NoMatch;

    getLexer().Lex();
    Operands.push_back(BPFOperand::createReg(RegNo, S, E));
  }
  return MatchOperand_Success;
}

OperandMatchResultTy BPFAsmParser::parseImmediate(OperandVector &Operands) {
  switch (getLexer().getKind()) {
  default:
    return MatchOperand_NoMatch;
  case AsmToken::LParen:
  case AsmToken::Minus:
  case AsmToken::Plus:
  case AsmToken::Integer:
  case AsmToken::String:
  case AsmToken::Identifier:
    break;
  }

  const MCExpr *IdVal;
  SMLoc S = getLoc();

  if (getParser().parseExpression(IdVal))
    return MatchOperand_ParseFail;

  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
  Operands.push_back(BPFOperand::createImm(IdVal, S, E));

  return MatchOperand_Success;
}

/// ParseInstruction - Parse an BPF instruction which is in BPF verifier
/// format.
bool BPFAsmParser::ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                                    SMLoc NameLoc, OperandVector &Operands) {
  // The first operand could be either register or actually an operator.
  unsigned RegNo = MatchRegisterName(Name);

  if (RegNo != 0) {
    SMLoc E = SMLoc::getFromPointer(NameLoc.getPointer() - 1);
    Operands.push_back(BPFOperand::createReg(RegNo, NameLoc, E));
  } else if (BPFOperand::isValidIdAtStart (Name))
    Operands.push_back(BPFOperand::createToken(Name, NameLoc));
  else
    return true;

  while (!getLexer().is(AsmToken::EndOfStatement)) {
    // Attempt to parse token as operator
    if (parseOperandAsOperator(Operands) == MatchOperand_Success)
      continue;

    // Attempt to parse token as register
    if (parseRegister(Operands) == MatchOperand_Success)
      continue;

    // Attempt to parse token as an immediate
    if (parseImmediate(Operands) != MatchOperand_Success)
      return true;
  }

  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    SMLoc Loc = getLexer().getLoc();

    getParser().eatToEndOfStatement();

    return Error(Loc, "unexpected token");
  }

  // Consume the EndOfStatement.
  getParser().Lex();
  return false;
}

bool BPFAsmParser::ParseDirective(AsmToken DirectiveID) { return true; }

extern "C" void LLVMInitializeBPFAsmParser() {
  RegisterMCAsmParser<BPFAsmParser> X(getTheBPFTarget());
  RegisterMCAsmParser<BPFAsmParser> Y(getTheBPFleTarget());
  RegisterMCAsmParser<BPFAsmParser> Z(getTheBPFbeTarget());
}
