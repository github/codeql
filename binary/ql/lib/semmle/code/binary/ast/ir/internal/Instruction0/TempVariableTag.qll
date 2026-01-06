newtype TTempVariableTag =
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
  CilLdcConstVarTag() or
  CilLdLocVarTag() or
  CilBinaryVarTag() or
  CilRelSubVarTag() or
  CilRelVarTag() or
  CilBoolBranchConstVarTag() or
  CilBoolBranchSubVarTag() or
  CilUnconditionalBranchRefVarTag() or
  CallReturnValueTag() or
  CilCallTargetVarTag() or
  CilLoadStringVarTag() or
  CilLoadArgVarTag() or
  CilLdindVarTag() or
  CilNewObjInitVarTag() or
  CilNewObjCallExternalVarTag() or
  CilDupVarTag() or
  CilStoreFieldAddressVarTag() or
  CilLoadFieldAddressVarTag() or
  CilLoadFieldLoadVarTag() or
  // JVM temp variable tags
  JvmCallTargetVarTag() or
  JvmCallResultVarTag() or
  JvmLoadLocalResultVarTag() or
  JvmConstResultVarTag() or
  JvmDupResultVarTag() or
  JvmArithResultVarTag() or
  JvmNewResultVarTag() or
  JvmFieldAddressVarTag() or
  JvmFieldLoadResultVarTag()

class TempVariableTag extends TTempVariableTag {
  string toString() {
    this = TestVarTag() and
    result = "t"
    or
    this = ZeroVarTag() and
    result = "z"
    or
    this = ImmediateOperandVarTag() and
    result = "i"
    or
    this = MemoryOperandLoadVarTag() and
    result = "ml"
    or
    this = MemoryOperandConstFactorVarTag() and
    result = "mcf"
    or
    this = MemoryOperandConstDisplacementVarTag() and
    result = "mcd"
    or
    this = PushConstVarTag() and
    result = "pu"
    or
    this = PopConstVarTag() and
    result = "po"
    or
    this = DecOrIncConstVarTag() and
    result = "cre"
    or
    this = BtVarTag() and
    result = "bt"
    or
    this = BtOneVarTag() and
    result = "bt1"
    or
    this = BtZeroVarTag() and
    result = "bt0"
    or
    this = BtrVarTag() and
    result = "btr"
    or
    this = BtrOneVarTag() and
    result = "btr1"
    or
    this = MemoryOperandMulVarTag() and
    result = "mmul"
    or
    this = MemoryOperandAdd1VarTag() and
    result = "madd1"
    or
    this = MemoryOperandAdd2VarTag() and
    result = "madd2"
    or
    this = NegConstZeroVarTag() and
    result = "neg0"
    or
    this = CilLdcConstVarTag() and
    result = "c"
    or
    this = CilLdLocVarTag() and
    result = "v"
    or
    this = CilBinaryVarTag() and
    result = "b"
    or
    this = CilRelSubVarTag() and
    result = "r_s"
    or
    this = CilRelVarTag() and
    result = "r"
    or
    this = CilBoolBranchConstVarTag() and
    result = "cbb_c"
    or
    this = CilBoolBranchSubVarTag() and
    result = "cbb_s"
    or
    this = CilUnconditionalBranchRefVarTag() and
    result = "cub_ir"
    or
    this = CallReturnValueTag() and
    result = "call_ret"
    or
    this = CilCallTargetVarTag() and
    result = "call_target"
    or
    this = CilLoadStringVarTag() and
    result = "ldstr"
    or
    this = CilLoadArgVarTag() and
    result = "ldarg"
    or
    this = CilLdindVarTag() and
    result = "ldind"
    or
    this = CilNewObjInitVarTag() and
    result = "newobj"
    or
    this = CilNewObjCallExternalVarTag() and
    result = "newobj_ext"
    or
    this = CilDupVarTag() and
    result = "dup"
    or
    this = CilStoreFieldAddressVarTag() and
    result = "stfldaddr"
    or
    this = CilLoadFieldAddressVarTag() and
    result = "ldfldaddr"
    or
    this = CilLoadFieldLoadVarTag() and
    result = "ldfld"
    or
    // JVM temp variable tags
    this = JvmCallTargetVarTag() and
    result = "jvm_call_target"
    or
    this = JvmCallResultVarTag() and
    result = "jvm_call_ret"
    or
    this = JvmLoadLocalResultVarTag() and
    result = "jvm_ldloc"
    or
    this = JvmConstResultVarTag() and
    result = "jvm_const"
    or
    this = JvmDupResultVarTag() and
    result = "jvm_dup"
    or
    this = JvmArithResultVarTag() and
    result = "jvm_arith"
    or
    this = JvmNewResultVarTag() and
    result = "jvm_new"
    or
    this = JvmFieldAddressVarTag() and
    result = "jvm_fldaddr"
    or
    this = JvmFieldLoadResultVarTag() and
    result = "jvm_ldfld"
  }
}
