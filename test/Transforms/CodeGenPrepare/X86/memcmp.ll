; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -codegenprepare -mtriple=i686-unknown-unknown   -data-layout=e-m:o-p:32:32-f64:32:64-f80:128-n8:16:32-S128 < %s | FileCheck %s --check-prefix=ALL --check-prefix=X32
; RUN: opt -S -codegenprepare -mtriple=x86_64-unknown-unknown -data-layout=e-m:o-i64:64-f80:128-n8:16:32:64-S128         < %s | FileCheck %s --check-prefix=ALL --check-prefix=X64

declare i32 @memcmp(i8* nocapture, i8* nocapture, i64)

define i32 @cmp2(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp2(
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i16*
; ALL-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i16*
; ALL-NEXT:    [[TMP3:%.*]] = load i16, i16* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = load i16, i16* [[TMP2]]
; ALL-NEXT:    [[TMP5:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP3]])
; ALL-NEXT:    [[TMP6:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP4]])
; ALL-NEXT:    [[TMP7:%.*]] = zext i16 [[TMP5]] to i32
; ALL-NEXT:    [[TMP8:%.*]] = zext i16 [[TMP6]] to i32
; ALL-NEXT:    [[TMP9:%.*]] = sub i32 [[TMP7]], [[TMP8]]
; ALL-NEXT:    ret i32 [[TMP9]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 2)
  ret i32 %call
}

define i32 @cmp3(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp3(
; ALL-NEXT:  loadbb:
; ALL-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i16*
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i16*
; ALL-NEXT:    [[TMP2:%.*]] = load i16, i16* [[TMP0]]
; ALL-NEXT:    [[TMP3:%.*]] = load i16, i16* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP2]])
; ALL-NEXT:    [[TMP5:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP3]])
; ALL-NEXT:    [[TMP6:%.*]] = icmp eq i16 [[TMP4]], [[TMP5]]
; ALL-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; ALL:       res_block:
; ALL-NEXT:    [[TMP7:%.*]] = icmp ult i16 [[TMP4]], [[TMP5]]
; ALL-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; ALL-NEXT:    br label [[ENDBLOCK:%.*]]
; ALL:       loadbb1:
; ALL-NEXT:    [[TMP9:%.*]] = getelementptr i8, i8* [[X]], i8 2
; ALL-NEXT:    [[TMP10:%.*]] = getelementptr i8, i8* [[Y]], i8 2
; ALL-NEXT:    [[TMP11:%.*]] = load i8, i8* [[TMP9]]
; ALL-NEXT:    [[TMP12:%.*]] = load i8, i8* [[TMP10]]
; ALL-NEXT:    [[TMP13:%.*]] = zext i8 [[TMP11]] to i32
; ALL-NEXT:    [[TMP14:%.*]] = zext i8 [[TMP12]] to i32
; ALL-NEXT:    [[TMP15:%.*]] = sub i32 [[TMP13]], [[TMP14]]
; ALL-NEXT:    br label [[ENDBLOCK]]
; ALL:       endblock:
; ALL-NEXT:    [[PHI_RES:%.*]] = phi i32 [ [[TMP15]], [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; ALL-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 3)
  ret i32 %call
}

define i32 @cmp4(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp4(
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i32*
; ALL-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; ALL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP2]]
; ALL-NEXT:    [[TMP5:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP3]])
; ALL-NEXT:    [[TMP6:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP4]])
; ALL-NEXT:    [[TMP7:%.*]] = icmp ugt i32 [[TMP5]], [[TMP6]]
; ALL-NEXT:    [[TMP8:%.*]] = icmp ult i32 [[TMP5]], [[TMP6]]
; ALL-NEXT:    [[TMP9:%.*]] = zext i1 [[TMP7]] to i32
; ALL-NEXT:    [[TMP10:%.*]] = zext i1 [[TMP8]] to i32
; ALL-NEXT:    [[TMP11:%.*]] = sub i32 [[TMP9]], [[TMP10]]
; ALL-NEXT:    ret i32 [[TMP11]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 4)
  ret i32 %call
}

define i32 @cmp5(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp5(
; ALL-NEXT:  loadbb:
; ALL-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i32*
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; ALL-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]]
; ALL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP2]])
; ALL-NEXT:    [[TMP5:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP3]])
; ALL-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[TMP4]], [[TMP5]]
; ALL-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; ALL:       res_block:
; ALL-NEXT:    [[TMP7:%.*]] = icmp ult i32 [[TMP4]], [[TMP5]]
; ALL-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; ALL-NEXT:    br label [[ENDBLOCK:%.*]]
; ALL:       loadbb1:
; ALL-NEXT:    [[TMP9:%.*]] = getelementptr i8, i8* [[X]], i8 4
; ALL-NEXT:    [[TMP10:%.*]] = getelementptr i8, i8* [[Y]], i8 4
; ALL-NEXT:    [[TMP11:%.*]] = load i8, i8* [[TMP9]]
; ALL-NEXT:    [[TMP12:%.*]] = load i8, i8* [[TMP10]]
; ALL-NEXT:    [[TMP13:%.*]] = zext i8 [[TMP11]] to i32
; ALL-NEXT:    [[TMP14:%.*]] = zext i8 [[TMP12]] to i32
; ALL-NEXT:    [[TMP15:%.*]] = sub i32 [[TMP13]], [[TMP14]]
; ALL-NEXT:    br label [[ENDBLOCK]]
; ALL:       endblock:
; ALL-NEXT:    [[PHI_RES:%.*]] = phi i32 [ [[TMP15]], [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; ALL-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 5)
  ret i32 %call
}

define i32 @cmp6(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp6(
; ALL-NEXT:  loadbb:
; ALL-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i32*
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; ALL-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]]
; ALL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP2]])
; ALL-NEXT:    [[TMP5:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP3]])
; ALL-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[TMP4]], [[TMP5]]
; ALL-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; ALL:       res_block:
; ALL-NEXT:    [[PHI_SRC1:%.*]] = phi i32 [ [[TMP4]], [[LOADBB:%.*]] ], [ [[TMP17:%.*]], [[LOADBB1]] ]
; ALL-NEXT:    [[PHI_SRC2:%.*]] = phi i32 [ [[TMP5]], [[LOADBB]] ], [ [[TMP18:%.*]], [[LOADBB1]] ]
; ALL-NEXT:    [[TMP7:%.*]] = icmp ult i32 [[PHI_SRC1]], [[PHI_SRC2]]
; ALL-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; ALL-NEXT:    br label [[ENDBLOCK:%.*]]
; ALL:       loadbb1:
; ALL-NEXT:    [[TMP9:%.*]] = bitcast i8* [[X]] to i16*
; ALL-NEXT:    [[TMP10:%.*]] = bitcast i8* [[Y]] to i16*
; ALL-NEXT:    [[TMP11:%.*]] = getelementptr i16, i16* [[TMP9]], i16 2
; ALL-NEXT:    [[TMP12:%.*]] = getelementptr i16, i16* [[TMP10]], i16 2
; ALL-NEXT:    [[TMP13:%.*]] = load i16, i16* [[TMP11]]
; ALL-NEXT:    [[TMP14:%.*]] = load i16, i16* [[TMP12]]
; ALL-NEXT:    [[TMP15:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP13]])
; ALL-NEXT:    [[TMP16:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP14]])
; ALL-NEXT:    [[TMP17]] = zext i16 [[TMP15]] to i32
; ALL-NEXT:    [[TMP18]] = zext i16 [[TMP16]] to i32
; ALL-NEXT:    [[TMP19:%.*]] = icmp eq i32 [[TMP17]], [[TMP18]]
; ALL-NEXT:    br i1 [[TMP19]], label [[ENDBLOCK]], label [[RES_BLOCK]]
; ALL:       endblock:
; ALL-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; ALL-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 6)
  ret i32 %call
}

define i32 @cmp7(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp7(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 7)
; ALL-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 7)
  ret i32 %call
}

define i32 @cmp8(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp8(
; X32-NEXT:  loadbb:
; X32-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i32*
; X32-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; X32-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]]
; X32-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; X32-NEXT:    [[TMP4:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP2]])
; X32-NEXT:    [[TMP5:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP3]])
; X32-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[TMP4]], [[TMP5]]
; X32-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; X32:       res_block:
; X32-NEXT:    [[PHI_SRC1:%.*]] = phi i32 [ [[TMP4]], [[LOADBB:%.*]] ], [ [[TMP15:%.*]], [[LOADBB1]] ]
; X32-NEXT:    [[PHI_SRC2:%.*]] = phi i32 [ [[TMP5]], [[LOADBB]] ], [ [[TMP16:%.*]], [[LOADBB1]] ]
; X32-NEXT:    [[TMP7:%.*]] = icmp ult i32 [[PHI_SRC1]], [[PHI_SRC2]]
; X32-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; X32-NEXT:    br label [[ENDBLOCK:%.*]]
; X32:       loadbb1:
; X32-NEXT:    [[TMP9:%.*]] = bitcast i8* [[X]] to i32*
; X32-NEXT:    [[TMP10:%.*]] = bitcast i8* [[Y]] to i32*
; X32-NEXT:    [[TMP11:%.*]] = getelementptr i32, i32* [[TMP9]], i32 1
; X32-NEXT:    [[TMP12:%.*]] = getelementptr i32, i32* [[TMP10]], i32 1
; X32-NEXT:    [[TMP13:%.*]] = load i32, i32* [[TMP11]]
; X32-NEXT:    [[TMP14:%.*]] = load i32, i32* [[TMP12]]
; X32-NEXT:    [[TMP15]] = call i32 @llvm.bswap.i32(i32 [[TMP13]])
; X32-NEXT:    [[TMP16]] = call i32 @llvm.bswap.i32(i32 [[TMP14]])
; X32-NEXT:    [[TMP17:%.*]] = icmp eq i32 [[TMP15]], [[TMP16]]
; X32-NEXT:    br i1 [[TMP17]], label [[ENDBLOCK]], label [[RES_BLOCK]]
; X32:       endblock:
; X32-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; X32-NEXT:    ret i32 [[PHI_RES]]
;
; X64-LABEL: @cmp8(
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = load i64, i64* [[TMP2]]
; X64-NEXT:    [[TMP5:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP3]])
; X64-NEXT:    [[TMP6:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP4]])
; X64-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[TMP5]], [[TMP6]]
; X64-NEXT:    [[TMP8:%.*]] = icmp ult i64 [[TMP5]], [[TMP6]]
; X64-NEXT:    [[TMP9:%.*]] = zext i1 [[TMP7]] to i32
; X64-NEXT:    [[TMP10:%.*]] = zext i1 [[TMP8]] to i32
; X64-NEXT:    [[TMP11:%.*]] = sub i32 [[TMP9]], [[TMP10]]
; X64-NEXT:    ret i32 [[TMP11]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 8)
  ret i32 %call
}

define i32 @cmp9(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp9(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 9)
; X32-NEXT:    ret i32 [[CALL]]
;
; X64-LABEL: @cmp9(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP2]])
; X64-NEXT:    [[TMP5:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP3]])
; X64-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[TMP4]], [[TMP5]]
; X64-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; X64:       res_block:
; X64-NEXT:    [[TMP7:%.*]] = icmp ult i64 [[TMP4]], [[TMP5]]
; X64-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP9:%.*]] = getelementptr i8, i8* [[X]], i8 8
; X64-NEXT:    [[TMP10:%.*]] = getelementptr i8, i8* [[Y]], i8 8
; X64-NEXT:    [[TMP11:%.*]] = load i8, i8* [[TMP9]]
; X64-NEXT:    [[TMP12:%.*]] = load i8, i8* [[TMP10]]
; X64-NEXT:    [[TMP13:%.*]] = zext i8 [[TMP11]] to i32
; X64-NEXT:    [[TMP14:%.*]] = zext i8 [[TMP12]] to i32
; X64-NEXT:    [[TMP15:%.*]] = sub i32 [[TMP13]], [[TMP14]]
; X64-NEXT:    br label [[ENDBLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ [[TMP15]], [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; X64-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 9)
  ret i32 %call
}

define i32 @cmp10(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp10(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 10)
; X32-NEXT:    ret i32 [[CALL]]
;
; X64-LABEL: @cmp10(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP2]])
; X64-NEXT:    [[TMP5:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP3]])
; X64-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[TMP4]], [[TMP5]]
; X64-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; X64:       res_block:
; X64-NEXT:    [[PHI_SRC1:%.*]] = phi i64 [ [[TMP4]], [[LOADBB:%.*]] ], [ [[TMP17:%.*]], [[LOADBB1]] ]
; X64-NEXT:    [[PHI_SRC2:%.*]] = phi i64 [ [[TMP5]], [[LOADBB]] ], [ [[TMP18:%.*]], [[LOADBB1]] ]
; X64-NEXT:    [[TMP7:%.*]] = icmp ult i64 [[PHI_SRC1]], [[PHI_SRC2]]
; X64-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP9:%.*]] = bitcast i8* [[X]] to i16*
; X64-NEXT:    [[TMP10:%.*]] = bitcast i8* [[Y]] to i16*
; X64-NEXT:    [[TMP11:%.*]] = getelementptr i16, i16* [[TMP9]], i16 4
; X64-NEXT:    [[TMP12:%.*]] = getelementptr i16, i16* [[TMP10]], i16 4
; X64-NEXT:    [[TMP13:%.*]] = load i16, i16* [[TMP11]]
; X64-NEXT:    [[TMP14:%.*]] = load i16, i16* [[TMP12]]
; X64-NEXT:    [[TMP15:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP13]])
; X64-NEXT:    [[TMP16:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP14]])
; X64-NEXT:    [[TMP17]] = zext i16 [[TMP15]] to i64
; X64-NEXT:    [[TMP18]] = zext i16 [[TMP16]] to i64
; X64-NEXT:    [[TMP19:%.*]] = icmp eq i64 [[TMP17]], [[TMP18]]
; X64-NEXT:    br i1 [[TMP19]], label [[ENDBLOCK]], label [[RES_BLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; X64-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 10)
  ret i32 %call
}

define i32 @cmp11(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp11(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 11)
; ALL-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 11)
  ret i32 %call
}

define i32 @cmp12(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp12(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 12)
; X32-NEXT:    ret i32 [[CALL]]
;
; X64-LABEL: @cmp12(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP2]])
; X64-NEXT:    [[TMP5:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP3]])
; X64-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[TMP4]], [[TMP5]]
; X64-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; X64:       res_block:
; X64-NEXT:    [[PHI_SRC1:%.*]] = phi i64 [ [[TMP4]], [[LOADBB:%.*]] ], [ [[TMP17:%.*]], [[LOADBB1]] ]
; X64-NEXT:    [[PHI_SRC2:%.*]] = phi i64 [ [[TMP5]], [[LOADBB]] ], [ [[TMP18:%.*]], [[LOADBB1]] ]
; X64-NEXT:    [[TMP7:%.*]] = icmp ult i64 [[PHI_SRC1]], [[PHI_SRC2]]
; X64-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP9:%.*]] = bitcast i8* [[X]] to i32*
; X64-NEXT:    [[TMP10:%.*]] = bitcast i8* [[Y]] to i32*
; X64-NEXT:    [[TMP11:%.*]] = getelementptr i32, i32* [[TMP9]], i32 2
; X64-NEXT:    [[TMP12:%.*]] = getelementptr i32, i32* [[TMP10]], i32 2
; X64-NEXT:    [[TMP13:%.*]] = load i32, i32* [[TMP11]]
; X64-NEXT:    [[TMP14:%.*]] = load i32, i32* [[TMP12]]
; X64-NEXT:    [[TMP15:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP13]])
; X64-NEXT:    [[TMP16:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP14]])
; X64-NEXT:    [[TMP17]] = zext i32 [[TMP15]] to i64
; X64-NEXT:    [[TMP18]] = zext i32 [[TMP16]] to i64
; X64-NEXT:    [[TMP19:%.*]] = icmp eq i64 [[TMP17]], [[TMP18]]
; X64-NEXT:    br i1 [[TMP19]], label [[ENDBLOCK]], label [[RES_BLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; X64-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 12)
  ret i32 %call
}

define i32 @cmp13(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp13(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 13)
; ALL-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 13)
  ret i32 %call
}

define i32 @cmp14(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp14(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 14)
; ALL-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 14)
  ret i32 %call
}

define i32 @cmp15(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp15(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 15)
; ALL-NEXT:    ret i32 [[CALL]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 15)
  ret i32 %call
}

define i32 @cmp16(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp16(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 16)
; X32-NEXT:    ret i32 [[CALL]]
;
; X64-LABEL: @cmp16(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP2]])
; X64-NEXT:    [[TMP5:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP3]])
; X64-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[TMP4]], [[TMP5]]
; X64-NEXT:    br i1 [[TMP6]], label [[LOADBB1:%.*]], label [[RES_BLOCK:%.*]]
; X64:       res_block:
; X64-NEXT:    [[PHI_SRC1:%.*]] = phi i64 [ [[TMP4]], [[LOADBB:%.*]] ], [ [[TMP15:%.*]], [[LOADBB1]] ]
; X64-NEXT:    [[PHI_SRC2:%.*]] = phi i64 [ [[TMP5]], [[LOADBB]] ], [ [[TMP16:%.*]], [[LOADBB1]] ]
; X64-NEXT:    [[TMP7:%.*]] = icmp ult i64 [[PHI_SRC1]], [[PHI_SRC2]]
; X64-NEXT:    [[TMP8:%.*]] = select i1 [[TMP7]], i32 -1, i32 1
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP9:%.*]] = bitcast i8* [[X]] to i64*
; X64-NEXT:    [[TMP10:%.*]] = bitcast i8* [[Y]] to i64*
; X64-NEXT:    [[TMP11:%.*]] = getelementptr i64, i64* [[TMP9]], i64 1
; X64-NEXT:    [[TMP12:%.*]] = getelementptr i64, i64* [[TMP10]], i64 1
; X64-NEXT:    [[TMP13:%.*]] = load i64, i64* [[TMP11]]
; X64-NEXT:    [[TMP14:%.*]] = load i64, i64* [[TMP12]]
; X64-NEXT:    [[TMP15]] = call i64 @llvm.bswap.i64(i64 [[TMP13]])
; X64-NEXT:    [[TMP16]] = call i64 @llvm.bswap.i64(i64 [[TMP14]])
; X64-NEXT:    [[TMP17:%.*]] = icmp eq i64 [[TMP15]], [[TMP16]]
; X64-NEXT:    br i1 [[TMP17]], label [[ENDBLOCK]], label [[RES_BLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ [[TMP8]], [[RES_BLOCK]] ]
; X64-NEXT:    ret i32 [[PHI_RES]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 16)
  ret i32 %call
}

define i32 @cmp_eq2(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq2(
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i16*
; ALL-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i16*
; ALL-NEXT:    [[TMP3:%.*]] = load i16, i16* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = load i16, i16* [[TMP2]]
; ALL-NEXT:    [[TMP5:%.*]] = icmp ne i16 [[TMP3]], [[TMP4]]
; ALL-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP5]] to i32
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP6]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 2)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq3(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq3(
; ALL-NEXT:  loadbb:
; ALL-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i16*
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i16*
; ALL-NEXT:    [[TMP2:%.*]] = load i16, i16* [[TMP0]]
; ALL-NEXT:    [[TMP3:%.*]] = load i16, i16* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = icmp ne i16 [[TMP2]], [[TMP3]]
; ALL-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; ALL:       res_block:
; ALL-NEXT:    br label [[ENDBLOCK:%.*]]
; ALL:       loadbb1:
; ALL-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[X]], i8 2
; ALL-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[Y]], i8 2
; ALL-NEXT:    [[TMP7:%.*]] = load i8, i8* [[TMP5]]
; ALL-NEXT:    [[TMP8:%.*]] = load i8, i8* [[TMP6]]
; ALL-NEXT:    [[TMP9:%.*]] = icmp ne i8 [[TMP7]], [[TMP8]]
; ALL-NEXT:    br i1 [[TMP9]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; ALL:       endblock:
; ALL-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 3)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq4(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq4(
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i32*
; ALL-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; ALL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP2]]
; ALL-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP3]], [[TMP4]]
; ALL-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP5]] to i32
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP6]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 4)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq5(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq5(
; ALL-NEXT:  loadbb:
; ALL-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i32*
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; ALL-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]]
; ALL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP2]], [[TMP3]]
; ALL-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; ALL:       res_block:
; ALL-NEXT:    br label [[ENDBLOCK:%.*]]
; ALL:       loadbb1:
; ALL-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[X]], i8 4
; ALL-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[Y]], i8 4
; ALL-NEXT:    [[TMP7:%.*]] = load i8, i8* [[TMP5]]
; ALL-NEXT:    [[TMP8:%.*]] = load i8, i8* [[TMP6]]
; ALL-NEXT:    [[TMP9:%.*]] = icmp ne i8 [[TMP7]], [[TMP8]]
; ALL-NEXT:    br i1 [[TMP9]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; ALL:       endblock:
; ALL-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 5)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq6(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq6(
; ALL-NEXT:  loadbb:
; ALL-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i32*
; ALL-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; ALL-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]]
; ALL-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; ALL-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP2]], [[TMP3]]
; ALL-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; ALL:       res_block:
; ALL-NEXT:    br label [[ENDBLOCK:%.*]]
; ALL:       loadbb1:
; ALL-NEXT:    [[TMP5:%.*]] = bitcast i8* [[X]] to i16*
; ALL-NEXT:    [[TMP6:%.*]] = bitcast i8* [[Y]] to i16*
; ALL-NEXT:    [[TMP7:%.*]] = getelementptr i16, i16* [[TMP5]], i16 2
; ALL-NEXT:    [[TMP8:%.*]] = getelementptr i16, i16* [[TMP6]], i16 2
; ALL-NEXT:    [[TMP9:%.*]] = load i16, i16* [[TMP7]]
; ALL-NEXT:    [[TMP10:%.*]] = load i16, i16* [[TMP8]]
; ALL-NEXT:    [[TMP11:%.*]] = icmp ne i16 [[TMP9]], [[TMP10]]
; ALL-NEXT:    br i1 [[TMP11]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; ALL:       endblock:
; ALL-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 6)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq7(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq7(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 7)
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 7)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq8(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp_eq8(
; X32-NEXT:  loadbb:
; X32-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i32*
; X32-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i32*
; X32-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]]
; X32-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]]
; X32-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP2]], [[TMP3]]
; X32-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; X32:       res_block:
; X32-NEXT:    br label [[ENDBLOCK:%.*]]
; X32:       loadbb1:
; X32-NEXT:    [[TMP5:%.*]] = bitcast i8* [[X]] to i32*
; X32-NEXT:    [[TMP6:%.*]] = bitcast i8* [[Y]] to i32*
; X32-NEXT:    [[TMP7:%.*]] = getelementptr i32, i32* [[TMP5]], i32 1
; X32-NEXT:    [[TMP8:%.*]] = getelementptr i32, i32* [[TMP6]], i32 1
; X32-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP7]]
; X32-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP8]]
; X32-NEXT:    [[TMP11:%.*]] = icmp ne i32 [[TMP9]], [[TMP10]]
; X32-NEXT:    br i1 [[TMP11]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; X32:       endblock:
; X32-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; X32-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; X32-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X32-NEXT:    ret i32 [[CONV]]
;
; X64-LABEL: @cmp_eq8(
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = load i64, i64* [[TMP2]]
; X64-NEXT:    [[TMP5:%.*]] = icmp ne i64 [[TMP3]], [[TMP4]]
; X64-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP5]] to i32
; X64-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP6]], 0
; X64-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X64-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 8)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq9(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp_eq9(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 9)
; X32-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; X32-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X32-NEXT:    ret i32 [[CONV]]
;
; X64-LABEL: @cmp_eq9(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP2]], [[TMP3]]
; X64-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; X64:       res_block:
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[X]], i8 8
; X64-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[Y]], i8 8
; X64-NEXT:    [[TMP7:%.*]] = load i8, i8* [[TMP5]]
; X64-NEXT:    [[TMP8:%.*]] = load i8, i8* [[TMP6]]
; X64-NEXT:    [[TMP9:%.*]] = icmp ne i8 [[TMP7]], [[TMP8]]
; X64-NEXT:    br i1 [[TMP9]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; X64-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; X64-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X64-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 9)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq10(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp_eq10(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 10)
; X32-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; X32-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X32-NEXT:    ret i32 [[CONV]]
;
; X64-LABEL: @cmp_eq10(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP2]], [[TMP3]]
; X64-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; X64:       res_block:
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP5:%.*]] = bitcast i8* [[X]] to i16*
; X64-NEXT:    [[TMP6:%.*]] = bitcast i8* [[Y]] to i16*
; X64-NEXT:    [[TMP7:%.*]] = getelementptr i16, i16* [[TMP5]], i16 4
; X64-NEXT:    [[TMP8:%.*]] = getelementptr i16, i16* [[TMP6]], i16 4
; X64-NEXT:    [[TMP9:%.*]] = load i16, i16* [[TMP7]]
; X64-NEXT:    [[TMP10:%.*]] = load i16, i16* [[TMP8]]
; X64-NEXT:    [[TMP11:%.*]] = icmp ne i16 [[TMP9]], [[TMP10]]
; X64-NEXT:    br i1 [[TMP11]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; X64-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; X64-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X64-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 10)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq11(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq11(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 11)
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 11)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq12(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp_eq12(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 12)
; X32-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; X32-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X32-NEXT:    ret i32 [[CONV]]
;
; X64-LABEL: @cmp_eq12(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP2]], [[TMP3]]
; X64-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; X64:       res_block:
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP5:%.*]] = bitcast i8* [[X]] to i32*
; X64-NEXT:    [[TMP6:%.*]] = bitcast i8* [[Y]] to i32*
; X64-NEXT:    [[TMP7:%.*]] = getelementptr i32, i32* [[TMP5]], i32 2
; X64-NEXT:    [[TMP8:%.*]] = getelementptr i32, i32* [[TMP6]], i32 2
; X64-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP7]]
; X64-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP8]]
; X64-NEXT:    [[TMP11:%.*]] = icmp ne i32 [[TMP9]], [[TMP10]]
; X64-NEXT:    br i1 [[TMP11]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; X64-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; X64-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X64-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 12)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq13(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq13(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 13)
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 13)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq14(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq14(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 14)
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 14)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq15(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; ALL-LABEL: @cmp_eq15(
; ALL-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 15)
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; ALL-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; ALL-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 15)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @cmp_eq16(i8* nocapture readonly %x, i8* nocapture readonly %y)  {
; X32-LABEL: @cmp_eq16(
; X32-NEXT:    [[CALL:%.*]] = tail call i32 @memcmp(i8* [[X:%.*]], i8* [[Y:%.*]], i64 16)
; X32-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CALL]], 0
; X32-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X32-NEXT:    ret i32 [[CONV]]
;
; X64-LABEL: @cmp_eq16(
; X64-NEXT:  loadbb:
; X64-NEXT:    [[TMP0:%.*]] = bitcast i8* [[X:%.*]] to i64*
; X64-NEXT:    [[TMP1:%.*]] = bitcast i8* [[Y:%.*]] to i64*
; X64-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; X64-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; X64-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP2]], [[TMP3]]
; X64-NEXT:    br i1 [[TMP4]], label [[RES_BLOCK:%.*]], label [[LOADBB1:%.*]]
; X64:       res_block:
; X64-NEXT:    br label [[ENDBLOCK:%.*]]
; X64:       loadbb1:
; X64-NEXT:    [[TMP5:%.*]] = bitcast i8* [[X]] to i64*
; X64-NEXT:    [[TMP6:%.*]] = bitcast i8* [[Y]] to i64*
; X64-NEXT:    [[TMP7:%.*]] = getelementptr i64, i64* [[TMP5]], i64 1
; X64-NEXT:    [[TMP8:%.*]] = getelementptr i64, i64* [[TMP6]], i64 1
; X64-NEXT:    [[TMP9:%.*]] = load i64, i64* [[TMP7]]
; X64-NEXT:    [[TMP10:%.*]] = load i64, i64* [[TMP8]]
; X64-NEXT:    [[TMP11:%.*]] = icmp ne i64 [[TMP9]], [[TMP10]]
; X64-NEXT:    br i1 [[TMP11]], label [[RES_BLOCK]], label [[ENDBLOCK]]
; X64:       endblock:
; X64-NEXT:    [[PHI_RES:%.*]] = phi i32 [ 0, [[LOADBB1]] ], [ 1, [[RES_BLOCK]] ]
; X64-NEXT:    [[CMP:%.*]] = icmp eq i32 [[PHI_RES]], 0
; X64-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; X64-NEXT:    ret i32 [[CONV]]
;
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 16)
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

