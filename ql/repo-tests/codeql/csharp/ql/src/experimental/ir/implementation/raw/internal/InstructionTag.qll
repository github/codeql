import csharp
import experimental.ir.Util

private predicate elementIsInitialized(int elementIndex) {
  exists(ArrayInitWithMod initList | initList.isInitialized(elementIndex))
}

newtype TInstructionTag =
  OnlyInstructionTag() or // Single instruction (not including implicit Load)
  InitializeThisTag() or
  InitializerVariableAddressTag() or
  InitializerLoadStringTag() or
  InitializerStoreTag() or
  ZeroPadStringConstantTag() or
  ZeroPadStringElementIndexTag() or
  ZeroPadStringElementAddressTag() or
  ZeroPadStringStoreTag() or
  AssignOperationLoadTag() or
  AssignOperationConvertLeftTag() or
  AssignOperationOpTag() or
  AssignmentConvertRightTag() or
  AssignOperationConvertResultTag() or
  AssignmentStoreTag() or
  CrementLoadTag() or
  CrementConstantTag() or
  CrementOpTag() or
  CrementStoreTag() or
  EnterFunctionTag() or
  ReturnValueAddressTag() or
  ReturnTag() or
  ExitFunctionTag() or
  AliasedDefinitionTag() or
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
  LoadTag() or // Implicit load due to lvalue-to-rvalue conversion
  AddressTag() or
  CatchTag() or
  ThrowTag() or
  UnwindTag() or
  InitializerUninitializedTag() or
  InitializerElementIndexTag(int elementIndex) { elementIsInitialized(elementIndex) } or
  InitializerElementAddressTag(int elementIndex) { elementIsInitialized(elementIndex) } or
  InitializerElementDefaultValueTag(int elementIndex) { elementIsInitialized(elementIndex) } or
  InitializerElementDefaultValueStoreTag(int elementIndex) { elementIsInitialized(elementIndex) } or
  // Added for C#
  NewObjTag() or
  // TODO: remove the need for indexing
  PointerAddTag(int index) { index in [0 .. 255] } or
  ElementsAddressTag(int index) { index in [0 .. 255] } or
  ConvertTag() or
  GeneratedNEQTag() or
  GeneratedConstantTag() or
  GeneratedBranchTag()

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
  tag = ZeroPadStringConstantTag() and result = "ZeroPadConst"
  or
  tag = ZeroPadStringElementIndexTag() and result = "ZeroPadElemIndex"
  or
  tag = ZeroPadStringElementAddressTag() and result = "ZeroPadElemAddr"
  or
  tag = ZeroPadStringStoreTag() and result = "ZeroPadStore"
  or
  tag = AssignOperationLoadTag() and result = "AssignOpLoad"
  or
  tag = AssignOperationConvertLeftTag() and result = "AssignOpConvLeft"
  or
  tag = AssignmentConvertRightTag() and result = "AssignConvRight"
  or
  tag = AssignOperationOpTag() and result = "AssignOpOp"
  or
  tag = AssignOperationConvertResultTag() and result = "AssignOpConvRes"
  or
  tag = AssignmentStoreTag() and result = "AssignStore"
  or
  tag = CrementLoadTag() and result = "CrementLoad"
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
  // Added for C#
  tag = NewObjTag() and result = "NewObj"
  or
  tag = ElementsAddressTag(_) and result = "ElementsAddress"
  or
  tag = PointerAddTag(_) and result = "PointerAdd"
  or
  tag = ConvertTag() and result = "Convert"
  or
  tag = GeneratedNEQTag() and result = "GeneratedNEQTag"
  or
  tag = GeneratedConstantTag() and result = "GeneratedConstantTag"
  or
  tag = GeneratedBranchTag() and result = "GeneratedBranchTag"
  or
  tag = AddressTag() and result = "AddressTag"
  or
  exists(int index, string tagName |
    (
      tag = InitializerElementIndexTag(index) and tagName = "InitElemIndex"
      or
      tag = InitializerElementAddressTag(index) and tagName = "InitElemAddr"
      or
      tag = InitializerElementDefaultValueTag(index) and tagName = "InitElemDefVal"
      or
      tag = InitializerElementDefaultValueStoreTag(index) and tagName = "InitElemDefValStore"
    ) and
    result = tagName + "(" + index + ")"
  )
}
