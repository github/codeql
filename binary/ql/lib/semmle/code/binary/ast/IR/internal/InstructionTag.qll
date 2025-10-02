newtype TInstructionTag =
  SingleTag() or
  WriteTag() or
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
  BtrAndTag()

class InstructionTag extends TInstructionTag {
  final string toString() {
    this = SingleTag() and
    result = "Single"
    or
    this = WriteTag() and
    result = "Write"
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
  }
}

newtype VariableTag =
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
  BtrOneVarTag()

newtype SynthRegisterTag = CmpRegisterTag()

string stringOfSynthRegisterTag(SynthRegisterTag tag) {
  tag = CmpRegisterTag() and
  result = "cmp_r"
}

string stringOfVariableTag(VariableTag tag) {
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
  result = "l"
  or
  tag = MemoryOperandConstFactorVarTag() and
  result = "m"
  or
  tag = MemoryOperandConstDisplacementVarTag() and
  result = "m"
  or
  tag = PushConstVarTag() and
  result = "p"
  or
  tag = PopConstVarTag() and
  result = "p"
  or
  tag = DecOrIncConstVarTag() and
  result = "dic"
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
  result = "m_mul"
  or
  tag = MemoryOperandAdd1VarTag() and
  result = "m_add1"
  or
  tag = MemoryOperandAdd2VarTag() and
  result = "m_add2"
}

newtype OperandTag =
  LeftTag() or
  RightTag() or
  UnaryTag() or
  StoreSourceTag() or
  StoreDestTag() or
  CallTargetTag() or
  CondTag() or
  JumpTargetTag()

int getOperandTagIndex(OperandTag tag) {
  tag = LeftTag() and
  result = 0
  or
  tag = RightTag() and
  result = 1
  or
  tag = UnaryTag() and
  result = 0
  or
  tag = StoreSourceTag() and
  result = 1
  or
  tag = StoreDestTag() and
  result = 0
  or
  tag = CallTargetTag() and
  result = 0
  or
  tag = JumpTargetTag() and
  result = 0
  or
  tag = CondTag() and
  result = 1
}

string stringOfOperandTag(OperandTag tag) {
  tag = LeftTag() and
  result = "Left"
  or
  tag = RightTag() and
  result = "Right"
  or
  tag = UnaryTag() and
  result = "Unary"
  or
  tag = StoreSourceTag() and
  result = "StoreSource"
  or
  tag = StoreDestTag() and
  result = "StoreDest"
  or
  tag = CallTargetTag() and
  result = "CallTarget"
  or
  tag = JumpTargetTag() and
  result = "JumpTarget"
  or
  tag = CondTag() and
  result = "CondJump"
}
