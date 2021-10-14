import csharp

newtype TTempVariableTag =
  ConditionValueTempVar() or
  ReturnValueTempVar() or
  ThrowTempVar() or
  LambdaTempVar() or
  ForeachEnumTempVar() or
  LockedVarTemp() or
  LockWasTakenTemp() or
  EllipsisTempVar() or
  ThisTempVar()

string getTempVariableTagId(TTempVariableTag tag) {
  tag = ConditionValueTempVar() and result = "CondVal"
  or
  tag = ReturnValueTempVar() and result = "Ret"
  or
  tag = ThrowTempVar() and result = "Throw"
  or
  tag = LambdaTempVar() and result = "Lambda"
  or
  tag = ForeachEnumTempVar() and result = "ForeachEnum"
  or
  tag = LockedVarTemp() and result = "LockedVarTemp"
  or
  tag = LockWasTakenTemp() and result = "LockWasTakenTemp"
  or
  tag = EllipsisTempVar() and result = "Ellipsis"
  or
  tag = ThisTempVar() and result = "This"
}
