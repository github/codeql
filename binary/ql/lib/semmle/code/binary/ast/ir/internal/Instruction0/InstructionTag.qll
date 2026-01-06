private import codeql.util.Boolean
private import semmle.code.binary.ast.ir.internal.Opcode
private import semmle.code.binary.ast.internal.CilInstructions

newtype TInstructionTag =
  SingleTag() or
  FunEntryTag() or
  WriteTag() or
  InitFramePtrTag() or
  InitStackPtrTag() or
  TestAndTag() or
  TestZeroTag() or
  TestCmpTag() or
  ImmediateOperandConstTag() or
  MemoryOperandConstFactorTag() or
  MemoryOperandConstDisplacementTag() or
  MemoryOperandMulTag() or
  MemoryOperandAdd1Tag() or
  MemoryOperandAdd2Tag() or
  MemoryOperandLoadTag() or
  PushSubTag() or
  PushStoreTag() or
  PushSubConstTag() or
  PopAddTag() or
  PopAddConstTag() or
  PopLoadTag() or
  DecOrIncConstTag() or
  DecOrIncOpTag() or
  BtShiftTag() or
  BtAndTag() or
  BtCmpTag() or
  BtOneTag() or
  BtZeroTag() or
  BtrOneTag() or
  BtrShiftTag() or
  BtrNotTag() or
  BtrAndTag() or
  NegConstZeroTag() or
  NegSubTag() or
  CilLdcSizeTag() or
  CilLdcConstTag() or
  CilLdcSubTag() or
  CilLdcWriteTag() or
  CilStlocLoadTag() or
  CilStlocAddTag() or
  CilStlocConstTag() or
  CilRelSubTag() or
  CilRelCJumpTag() or
  CilRelConstTag(Boolean b) or
  CilBoolBranchSubTag() or
  CilBoolBranchConstTag() or
  CilBoolBranchCJumpTag() or
  CilCallTag() or
  CilCallTargetTag() or
  CilLdindLoadTag() or
  CilStindStoreTag() or
  CilNewObjInitTag() or
  CilNewObjCallTag() or
  CilNewObjExternalRefTag() or
  CilStoreFieldAddressTag() or
  CilStoreFieldStoreTag() or
  CilLoadFieldAddressTag() or
  CilLoadFieldLoadTag() or
  // JVM instruction tags
  JvmCallTag() or
  JvmCallTargetTag() or
  JvmReturnTag() or
  JvmLoadLocalTag() or
  JvmStoreLocalTag() or
  JvmBranchCJumpTag() or
  JvmGotoJumpTag() or
  JvmArithOpTag() or
  JvmFieldAddressTag() or
  JvmFieldLoadTag() or
  JvmFieldStoreTag() or
  JvmNewInitTag() or
  JvmConstTag() or
  JvmDupCopyTag() or
  JvmPopTag() or
  JvmNopTag()

class InstructionTag extends TInstructionTag {
  final string toString() {
    this = SingleTag() and
    result = "Single"
    or
    this = FunEntryTag() and
    result = "FunEntry"
    or
    this = WriteTag() and
    result = "Write"
    or
    this = InitFramePtrTag() and
    result = "InitFramePtr"
    or
    this = InitStackPtrTag() and
    result = "InitStackPtr"
    or
    this = TestAndTag() and
    result = "TestAnd"
    or
    this = TestZeroTag() and
    result = "TestZero"
    or
    this = TestCmpTag() and
    result = "TestCmp"
    or
    this = ImmediateOperandConstTag() and
    result = "ImmediateOperandConst"
    or
    this = MemoryOperandConstFactorTag() and
    result = "MemoryOperandConstFactor"
    or
    this = MemoryOperandConstDisplacementTag() and
    result = "MemoryOperandConstDisplacement"
    or
    this = MemoryOperandMulTag() and
    result = "MemoryOperandMul"
    or
    this = MemoryOperandAdd1Tag() and
    result = "MemoryOperandAdd1"
    or
    this = MemoryOperandAdd2Tag() and
    result = "MemoryOperandAdd2"
    or
    this = MemoryOperandLoadTag() and
    result = "MemoryOperandLoad"
    or
    this = PushSubTag() and
    result = "PushSub"
    or
    this = PushStoreTag() and
    result = "PushStore"
    or
    this = PushSubConstTag() and
    result = "PushSubConst"
    or
    this = PopAddTag() and
    result = "PopAdd"
    or
    this = PopAddConstTag() and
    result = "PopAddConst"
    or
    this = PopLoadTag() and
    result = "PopLoad"
    or
    this = DecOrIncConstTag() and
    result = "DecOrIncConst"
    or
    this = DecOrIncOpTag() and
    result = "DecOrIncOp"
    or
    this = BtrOneTag() and
    result = "BtrOne"
    or
    this = BtrShiftTag() and
    result = "BtrShift"
    or
    this = BtrNotTag() and
    result = "BtrNot"
    or
    this = BtrAndTag() and
    result = "BtrAnd"
    or
    this = NegConstZeroTag() and
    result = "NegConstZero"
    or
    this = NegSubTag() and
    result = "NegSub"
    or
    this = CilLdcConstTag() and
    result = "CilLdcConst"
    or
    this = CilLdcSizeTag() and
    result = "CilLdcSize"
    or
    this = CilLdcSubTag() and
    result = "CilLdcSub"
    or
    this = CilLdcWriteTag() and
    result = "CilLdcWrite"
    or
    this = CilStlocLoadTag() and
    result = "CilStlocLoad"
    or
    this = CilStlocAddTag() and
    result = "CilStlocAdd"
    or
    this = CilStlocConstTag() and
    result = "CilStlocConst"
    or
    this = CilRelSubTag() and
    result = "CilRelSub"
    or
    this = CilRelCJumpTag() and
    result = "CilRelCJump"
    or
    exists(boolean b |
      this = CilRelConstTag(b) and
      result = "CilRelConst(" + b.toString() + ")"
    )
    or
    this = CilBoolBranchSubTag() and
    result = "CilBoolBranchSub"
    or
    this = CilBoolBranchConstTag() and
    result = "CilBoolBranchConst"
    or
    this = CilBoolBranchCJumpTag() and
    result = "CilBoolBranchCJump"
    or
    this = CilCallTag() and
    result = "CilCall"
    or
    this = CilCallTargetTag() and
    result = "CilCallTarget"
    or
    this = CilLdindLoadTag() and
    result = "CilLdindLoad"
    or
    this = CilStindStoreTag() and
    result = "CilStindStore"
    or
    this = CilNewObjInitTag() and
    result = "CilNewObjInit"
    or
    this = CilNewObjCallTag() and
    result = "CilNewObjCall"
    or
    this = CilNewObjExternalRefTag() and
    result = "CilNewObjExternalRef"
    or
    this = CilStoreFieldAddressTag() and
    result = "CilStoreFieldAddress"
    or
    this = CilStoreFieldStoreTag() and
    result = "CilStoreFieldStore"
    or
    this = CilLoadFieldAddressTag() and
    result = "CilLoadFieldAddress"
    or
    this = CilLoadFieldLoadTag() and
    result = "CilLoadFieldLoad"
    or
    // JVM instruction tags
    this = JvmCallTag() and
    result = "JvmCall"
    or
    this = JvmCallTargetTag() and
    result = "JvmCallTarget"
    or
    this = JvmReturnTag() and
    result = "JvmReturn"
    or
    this = JvmLoadLocalTag() and
    result = "JvmLoadLocal"
    or
    this = JvmStoreLocalTag() and
    result = "JvmStoreLocal"
    or
    this = JvmBranchCJumpTag() and
    result = "JvmBranchCJump"
    or
    this = JvmGotoJumpTag() and
    result = "JvmGotoJump"
    or
    this = JvmArithOpTag() and
    result = "JvmArithOp"
    or
    this = JvmFieldAddressTag() and
    result = "JvmFieldAddress"
    or
    this = JvmFieldLoadTag() and
    result = "JvmFieldLoad"
    or
    this = JvmFieldStoreTag() and
    result = "JvmFieldStore"
    or
    this = JvmNewInitTag() and
    result = "JvmNewInit"
    or
    this = JvmConstTag() and
    result = "JvmConst"
    or
    this = JvmDupCopyTag() and
    result = "JvmDupCopy"
    or
    this = JvmPopTag() and
    result = "JvmPop"
    or
    this = JvmNopTag() and
    result = "JvmNop"
  }
}

private newtype TOperandTag =
  TLeftTag() or
  TRightTag() or
  TUnaryTag() or
  TStoreValueTag() or
  TLoadAddressTag() or
  TStoreAddressTag() or
  TCallTargetTag() or
  TCondTag() or
  TCondJumpTargetTag() or
  TJumpTargetTag() or
  TCilOperandTag(int i) {
    i = [0 .. max(CilCallOrNewObject call, int k | k = call.getNumberOfArguments() | k)]
  }

abstract class OperandTag extends TOperandTag {
  abstract int getIndex();

  abstract OperandTag getSuccessorTag();

  final OperandTag getPredecessorTag() { result.getSuccessorTag() = this }

  abstract string toString();
}

class LeftTag extends OperandTag, TLeftTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() { result instanceof RightTag }

  final override string toString() { result = "Left" }
}

class RightTag extends OperandTag, TRightTag {
  final override int getIndex() { result = 1 }

  final override OperandTag getSuccessorTag() { none() }

  final override string toString() { result = "Right" }
}

class UnaryTag extends OperandTag, TUnaryTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() { none() }

  final override string toString() { result = "Unary" }
}

class StoreValueTag extends OperandTag, TStoreValueTag {
  final override int getIndex() { result = 1 }

  final override OperandTag getSuccessorTag() { none() }

  final override string toString() { result = "StoreValue" }
}

class LoadAddressTag extends OperandTag, TLoadAddressTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() { none() }

  final override string toString() { result = "LoadAddr" }
}

class StoreAddressTag extends OperandTag, TStoreAddressTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() { result instanceof StoreValueTag }

  final override string toString() { result = "StoreDest" }
}

class CallTargetTag extends OperandTag, TCallTargetTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() {
    // Note: This will be `none` on x86 DBs.
    result.(CilOperandTag).getCilIndex() = 0
  }

  final override string toString() { result = "CallTarget" }
}

class CondTag extends OperandTag, TCondTag {
  final override int getIndex() { result = 1 }

  final override OperandTag getSuccessorTag() { none() }

  final override string toString() { result = "CondJump" }
}

class CondJumpTargetTag extends OperandTag, TCondJumpTargetTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() { result instanceof CondTag }

  final override string toString() { result = "CondJumpTarget" }
}

class JumpTargetTag extends OperandTag, TJumpTargetTag {
  final override int getIndex() { result = 0 }

  final override OperandTag getSuccessorTag() { none() }

  final override string toString() { result = "JumpTarget" }
}

class CilOperandTag extends OperandTag, TCilOperandTag {
  final override int getIndex() { result = this.getCilIndex() }

  final int getCilIndex() { this = TCilOperandTag(result) }

  final override OperandTag getSuccessorTag() {
    exists(int i |
      this = TCilOperandTag(i) and
      result = TCilOperandTag(i + 1)
    )
  }

  final override string toString() { result = "CilOperand(" + this.getIndex().toString() + ")" }
}
