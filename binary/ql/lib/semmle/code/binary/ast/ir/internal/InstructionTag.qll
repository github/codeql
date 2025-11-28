private import Opcode

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
  Stage1ZeroTag() or
  Stage1CmpDefTag(ConditionKind k) or
  NegConstZeroTag() or
  NegSubTag()

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
    this = Stage1ZeroTag() and
    result = "Stage1Zero"
    or
    exists(ConditionKind k |
      this = Stage1CmpDefTag(k) and
      result = "Stage1CmpDef(" + stringOfConditionKind(k) + ")"
    )
    or
    this = NegConstZeroTag() and
    result = "NegConstZero"
    or
    this = NegSubTag() and
    result = "NegSub"
  }
}

newtype VariableTag =
  X86JumpInstrRefVarTag() or
  X86CJumpInstrRefVarTag() or
  TestVarTag() or
  ZeroVarTag() or
  ImmediateOperandVarTag() or
  MemoryOperandConstFactorVarTag() or
  MemoryOperandConstDisplacementVarTag() or
  MemoryOperandMulVarTag() or
  MemoryOperandAdd1VarTag() or
  MemoryOperandAdd2VarTag() or
  MemoryOperandLoadVarTag() or
  PushConstVarTag() or
  PopConstVarTag() or
  DecOrIncConstVarTag() or
  BtVarTag() or
  BtOneVarTag() or
  BtZeroVarTag() or
  BtrVarTag() or
  BtrOneVarTag() or
  NegConstZeroVarTag() or
  MemToSsaVarTag()

newtype SynthRegisterTag = CmpRegisterTag()

string stringOfSynthRegisterTag(SynthRegisterTag tag) {
  tag = CmpRegisterTag() and
  result = "cmp_r"
}

string stringOfVariableTag(VariableTag tag) {
  tag = X86JumpInstrRefVarTag() and
  result = "j_ir"
  or
  tag = X86CJumpInstrRefVarTag() and
  result = "cj_ir"
  or
  tag = TestVarTag() and
  result = "t"
  or
  tag = ZeroVarTag() and
  result = "z"
  or
  tag = ImmediateOperandVarTag() and
  result = "i"
  or
  tag = MemoryOperandLoadVarTag() and
  result = "ml"
  or
  tag = MemoryOperandConstFactorVarTag() and
  result = "mcf"
  or
  tag = MemoryOperandConstDisplacementVarTag() and
  result = "mcd"
  or
  tag = PushConstVarTag() and
  result = "pu"
  or
  tag = PopConstVarTag() and
  result = "po"
  or
  tag = DecOrIncConstVarTag() and
  result = "cre"
  or
  tag = BtVarTag() and
  result = "bt"
  or
  tag = BtOneVarTag() and
  result = "bt1"
  or
  tag = BtZeroVarTag() and
  result = "bt0"
  or
  tag = BtrVarTag() and
  result = "btr"
  or
  tag = BtrOneVarTag() and
  result = "btr1"
  or
  tag = MemoryOperandMulVarTag() and
  result = "mmul"
  or
  tag = MemoryOperandAdd1VarTag() and
  result = "madd1"
  or
  tag = MemoryOperandAdd2VarTag() and
  result = "madd2"
  or
  tag = NegConstZeroVarTag() and
  result = "neg0"
  or
  tag = MemToSsaVarTag() and
  result = "mem2ssa"
}

newtype TOperandTag =
  LeftTag() or
  RightTag() or
  UnaryTag() or
  StoreValueTag() or
  StoreAddressTag() or
  CallTargetTag() or
  CondTag() or
  CondJumpTargetTag() or
  JumpTargetTag()

class OperandTag extends TOperandTag {
  int getIndex() {
    this = LeftTag() and
    result = 0
    or
    this = RightTag() and
    result = 1
    or
    this = UnaryTag() and
    result = 0
    or
    this = StoreValueTag() and
    result = 1
    or
    this = StoreAddressTag() and
    result = 0
    or
    this = CallTargetTag() and
    result = 0
    or
    this = CondJumpTargetTag() and
    result = 0
    or
    this = CondTag() and
    result = 1
    or
    this = JumpTargetTag() and
    result = 0
  }

  OperandTag getSuccessorTag() {
    this = LeftTag() and
    result = RightTag()
    or
    this = StoreAddressTag() and
    result = StoreValueTag()
    or
    this = CondJumpTargetTag() and
    result = CondTag()
  }

  OperandTag getPredecessorTag() { this = result.getSuccessorTag() }

  string toString() {
    this = LeftTag() and
    result = "Left"
    or
    this = RightTag() and
    result = "Right"
    or
    this = UnaryTag() and
    result = "Unary"
    or
    this = StoreValueTag() and
    result = "StoreValue"
    or
    this = StoreAddressTag() and
    result = "StoreDest"
    or
    this = CallTargetTag() and
    result = "CallTarget"
    or
    this = CondJumpTargetTag() and
    result = "CondJumpTarget"
    or
    this = CondTag() and
    result = "CondJump"
    or
    this = JumpTargetTag() and
    result = "JumpTarget"
  }
}
