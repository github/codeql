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
  CallNoReturnTag() or
  AllocationSizeTag() or
  AllocationElementSizeTag() or
  AllocationExtentConvertTag() or
  ValueConditionCompareTag() or
  ValueConditionConstantTag() or
  ValueConditionConditionalBranchTag() or
  ValueConditionConditionalConstantTag() or
  ValueConditionConditionalCompareTag() or
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
  NotExprOperationTag() or
  NotExprConstantTag() or
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
  StructuredBindingAccessTag() or
  // The next three cases handle generation of the constants -1, 0 and 1 for __except handling.
  TryExceptGenerateNegativeOne() or
  TryExceptGenerateZero() or
  TryExceptGenerateOne() or
  // The next three cases handle generation of comparisons for __except handling.
  TryExceptCompareNegativeOne() or
  TryExceptCompareZero() or
  TryExceptCompareOne() or
  // The next three cases handle generation of branching for __except handling.
  TryExceptCompareNegativeOneBranch() or
  TryExceptCompareZeroBranch() or
  TryExceptCompareOneBranch() or
  ImplicitDestructorTag(int index) {
    exists(Expr e | exists(e.getImplicitDestructorCall(index))) or
    exists(Stmt s | exists(s.getImplicitDestructorCall(index)))
  } or
  CoAwaitBranchTag()

class InstructionTag extends TInstructionTag {
  final string toString() { result = getInstructionTagId(this) }
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
  tag = ValueConditionConditionalConstantTag() and result = "ValueConditionConditionalConstant"
  or
  tag = ValueConditionConditionalCompareTag() and result = "ValueConditionConditionalCompare"
  or
  tag = ValueConditionCompareTag() and result = "ValCondCondCompare"
  or
  tag = ValueConditionConstantTag() and result = "ValCondConstant"
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
  tag = NotExprOperationTag() and result = "NotExprOperation"
  or
  tag = NotExprConstantTag() and result = "NotExprWithBoolConversionConstant"
  or
  tag = ResultCopyTag() and result = "ResultCopy"
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
  or
  tag = TryExceptCompareNegativeOne() and result = "TryExceptCompareNegativeOne"
  or
  tag = TryExceptCompareZero() and result = "TryExceptCompareZero"
  or
  tag = TryExceptCompareOne() and result = "TryExceptCompareOne"
  or
  tag = TryExceptGenerateNegativeOne() and result = "TryExceptGenerateNegativeOne"
  or
  tag = TryExceptGenerateZero() and result = "TryExceptGenerateNegativeOne"
  or
  tag = TryExceptGenerateOne() and result = "TryExceptGenerateOne"
  or
  tag = TryExceptCompareNegativeOneBranch() and result = "TryExceptCompareNegativeOneBranch"
  or
  tag = TryExceptCompareZeroBranch() and result = "TryExceptCompareZeroBranch"
  or
  tag = TryExceptCompareOneBranch() and result = "TryExceptCompareOneBranch"
  or
  exists(int index |
    tag = ImplicitDestructorTag(index) and result = "ImplicitDestructor(" + index + ")"
  )
  or
  tag = CoAwaitBranchTag() and result = "CoAwaitBranch"
}
