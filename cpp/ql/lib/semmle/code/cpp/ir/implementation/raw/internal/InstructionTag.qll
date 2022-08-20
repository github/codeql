private import cpp

newtype TInstructionTag =
  OnlyInstructionTag() or // Single instruction (not including implicit Load)
  InitializerVariableAddressTag() or
  InitializerLoadStringTag() or
  InitializerStoreTag() or
  InitializerIndirectAddressTag() or
  InitializerIndirectStoreTag() or
  DynamicInitializationFlagAddressTag() or
  DynamicInitializationFlagLoadTag() or
  DynamicInitializationConditionalBranchTag() or
  DynamicInitializationFlagConstantTag() or
  DynamicInitializationFlagStoreTag() or
  ZeroPadStringConstantTag() or
  ZeroPadStringElementIndexTag() or
  ZeroPadStringElementAddressTag() or
  ZeroPadStringStoreTag() or
  AssignOperationConvertLeftTag() or
  AssignOperationOpTag() or
  AssignOperationConvertResultTag() or
  AssignmentStoreTag() or
  CrementConstantTag() or
  CrementOpTag() or
  CrementStoreTag() or
  EnterFunctionTag() or
  ReturnValueAddressTag() or
  ReturnTag() or
  ExitFunctionTag() or
  AliasedDefinitionTag() or
  InitializeNonLocalTag() or
  AliasedUseTag() or
  SwitchBranchTag() or
  CallTargetTag() or
  CallTag() or
  CallSideEffectTag() or
  AllocationSizeTag() or
  AllocationElementSizeTag() or
  AllocationExtentConvertTag() or
  ValueConditionConditionalBranchTag() or
  ConditionValueTrueTempAddressTag() or
  ConditionValueTrueConstantTag() or
  ConditionValueTrueStoreTag() or
  ConditionValueFalseTempAddressTag() or
  ConditionValueFalseConstantTag() or
  ConditionValueFalseStoreTag() or
  ConditionValueResultTempAddressTag() or
  ConditionValueResultLoadTag() or
  BoolConversionConstantTag() or
  BoolConversionCompareTag() or
  ResultCopyTag() or
  LoadTag() or // Implicit load due to lvalue-to-rvalue conversion
  CatchTag() or
  ThrowTag() or
  UnwindTag() or
  InitializerUninitializedTag() or
  InitializerFieldAddressTag() or
  InitializerFieldDefaultValueTag() or
  InitializerFieldDefaultValueStoreTag() or
  InitializerElementIndexTag() or
  InitializerElementAddressTag() or
  InitializerElementDefaultValueTag() or
  InitializerElementDefaultValueStoreTag() or
  VarArgsStartEllipsisAddressTag() or
  VarArgsStartTag() or
  VarArgsVAListLoadTag() or
  VarArgsArgAddressTag() or
  VarArgsArgLoadTag() or
  VarArgsMoveNextTag() or
  VarArgsVAListStoreTag() or
  AsmTag() or
  AsmInputTag(int elementIndex) { exists(AsmStmt asm | exists(asm.getChild(elementIndex))) } or
  ThisAddressTag() or
  ThisLoadTag() or
  StructuredBindingAccessTag()

class InstructionTag extends TInstructionTag {
  final string toString() { result = "Tag" }
}

/**
 * Gets a unique string for the instruction tag. Primarily used for generating
 * instruction IDs to ensure stable IR dumps.
 */
string getInstructionTagId(TInstructionTag tag) {
  tag = OnlyInstructionTag() and result = "Only" // Single instruction (not including implicit Load)
  or
  tag = InitializerVariableAddressTag() and result = "InitVarAddr"
  or
  tag = InitializerLoadStringTag() and result = "InitLoadStr"
  or
  tag = InitializerStoreTag() and result = "InitStore"
  or
  tag = InitializerUninitializedTag() and result = "InitUninit"
  or
  tag = InitializerIndirectAddressTag() and result = "InitIndirectAddr"
  or
  tag = InitializerIndirectStoreTag() and result = "InitIndirectStore"
  or
  tag = ZeroPadStringConstantTag() and result = "ZeroPadConst"
  or
  tag = ZeroPadStringElementIndexTag() and result = "ZeroPadElemIndex"
  or
  tag = ZeroPadStringElementAddressTag() and result = "ZeroPadElemAddr"
  or
  tag = ZeroPadStringStoreTag() and result = "ZeroPadStore"
  or
  tag = AssignOperationConvertLeftTag() and result = "AssignOpConvLeft"
  or
  tag = AssignOperationOpTag() and result = "AssignOpOp"
  or
  tag = AssignOperationConvertResultTag() and result = "AssignOpConvRes"
  or
  tag = AssignmentStoreTag() and result = "AssignStore"
  or
  tag = CrementConstantTag() and result = "CrementConst"
  or
  tag = CrementOpTag() and result = "CrementOp"
  or
  tag = CrementStoreTag() and result = "CrementStore"
  or
  tag = EnterFunctionTag() and result = "EnterFunc"
  or
  tag = ReturnValueAddressTag() and result = "RetValAddr"
  or
  tag = ReturnTag() and result = "Ret"
  or
  tag = ExitFunctionTag() and result = "ExitFunc"
  or
  tag = AliasedDefinitionTag() and result = "AliasedDef"
  or
  tag = InitializeNonLocalTag() and result = "InitNonLocal"
  or
  tag = AliasedUseTag() and result = "AliasedUse"
  or
  tag = SwitchBranchTag() and result = "SwitchBranch"
  or
  tag = CallTargetTag() and result = "CallTarget"
  or
  tag = CallTag() and result = "Call"
  or
  tag = CallSideEffectTag() and result = "CallSideEffect"
  or
  tag = AllocationSizeTag() and result = "AllocSize"
  or
  tag = AllocationElementSizeTag() and result = "AllocElemSize"
  or
  tag = AllocationExtentConvertTag() and result = "AllocExtConv"
  or
  tag = ValueConditionConditionalBranchTag() and result = "ValCondCondBranch"
  or
  tag = ConditionValueTrueTempAddressTag() and result = "CondValTrueTempAddr"
  or
  tag = ConditionValueTrueConstantTag() and result = "CondValTrueConst"
  or
  tag = ConditionValueTrueStoreTag() and result = "CondValTrueStore"
  or
  tag = ConditionValueFalseTempAddressTag() and result = "CondValFalseTempAddr"
  or
  tag = ConditionValueFalseConstantTag() and result = "CondValFalseConst"
  or
  tag = ConditionValueFalseStoreTag() and result = "CondValFalseStore"
  or
  tag = ConditionValueResultTempAddressTag() and result = "CondValResTempAddr"
  or
  tag = ConditionValueResultLoadTag() and result = "CondValResLoad"
  or
  tag = BoolConversionConstantTag() and result = "BoolConvConst"
  or
  tag = BoolConversionCompareTag() and result = "BoolConvComp"
  or
  tag = LoadTag() and result = "Load" // Implicit load due to lvalue-to-rvalue conversion
  or
  tag = CatchTag() and result = "Catch"
  or
  tag = ThrowTag() and result = "Throw"
  or
  tag = UnwindTag() and result = "Unwind"
  or
  tag = InitializerFieldAddressTag() and result = "InitFieldAddr"
  or
  tag = InitializerFieldDefaultValueTag() and result = "InitFieldDefVal"
  or
  tag = InitializerFieldDefaultValueStoreTag() and result = "InitFieldDefValStore"
  or
  tag = InitializerElementIndexTag() and result = "InitElemIndex"
  or
  tag = InitializerElementAddressTag() and result = "InitElemAddr"
  or
  tag = InitializerElementDefaultValueTag() and result = "InitElemDefVal"
  or
  tag = InitializerElementDefaultValueStoreTag() and result = "InitElemDefValStore"
  or
  tag = VarArgsStartEllipsisAddressTag() and result = "VarArgsStartEllipsisAddr"
  or
  tag = VarArgsStartTag() and result = "VarArgsStart"
  or
  tag = VarArgsVAListLoadTag() and result = "VarArgsVAListLoad"
  or
  tag = VarArgsArgAddressTag() and result = "VarArgsArgAddr"
  or
  tag = VarArgsArgLoadTag() and result = "VaArgsArgLoad"
  or
  tag = VarArgsMoveNextTag() and result = "VarArgsMoveNext"
  or
  tag = VarArgsVAListStoreTag() and result = "VarArgsVAListStore"
  or
  tag = AsmTag() and result = "Asm"
  or
  exists(int index | tag = AsmInputTag(index) and result = "AsmInputTag(" + index + ")")
  or
  tag = DynamicInitializationFlagAddressTag() and result = "DynInitFlagAddr"
  or
  tag = DynamicInitializationFlagLoadTag() and result = "DynInitFlagLoad"
  or
  tag = DynamicInitializationConditionalBranchTag() and result = "DynInitCondBranch"
  or
  tag = DynamicInitializationFlagConstantTag() and result = "DynInitFlagConst"
  or
  tag = DynamicInitializationFlagStoreTag() and result = "DynInitFlagStore"
  or
  tag = ThisAddressTag() and result = "ThisAddress"
  or
  tag = ThisLoadTag() and result = "ThisLoad"
  or
  tag = StructuredBindingAccessTag() and result = "StructuredBindingAccess"
}
