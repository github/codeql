private import codeql.util.Boolean
private import semmle.code.binary.ast.ir.internal.Opcode

newtype TInstructionTag =
  SingleTag() or
  X86JumpInstrRefTag() or
  X86JumpTag() or
  X86CJumpInstrRefTag() or
  X86CJumpTag() or
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
  CilRelRefTag() or
  CilBoolBranchRefTag() or
  CilBoolBranchSubTag() or
  CilBoolBranchConstTag() or
  CilBoolBranchCJumpTag() or
  CilUnconditionalBranchTag() or
  CilUnconditionalBranchRefTag()

class InstructionTag extends TInstructionTag {
  final string toString() {
    this = SingleTag() and
    result = "Single"
    or
    this = X86JumpInstrRefTag() and
    result = "X86JumpInstrRef"
    or
    this = X86JumpTag() and
    result = "X86Jump"
    or
    this = X86CJumpInstrRefTag() and
    result = "X86CJumpInstrRef"
    or
    this = X86CJumpTag() and
    result = "X86CJump"
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
    this = CilRelRefTag() and
    result = "CilRelRef"
    or
    this = CilBoolBranchRefTag() and
    result = "CilBoolBranchRef"
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
    this = CilUnconditionalBranchTag() and
    result = "CilUnconditionalBranch"
    or
    this = CilUnconditionalBranchRefTag() and
    result = "CilUnconditionalBranchRef"
  }
}
