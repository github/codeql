newtype TTempVariableTag =
  ConditionValueTempVar() or
  ReturnValueTempVar() or
  ThrowTempVar() or
  LambdaTempVar() or
  EllipsisTempVar()

string getTempVariableTagId(TTempVariableTag tag) {
  tag = ConditionValueTempVar() and result = "CondVal"
  or
  tag = ReturnValueTempVar() and result = "Ret"
  or
  tag = ThrowTempVar() and result = "Throw"
  or
  tag = LambdaTempVar() and result = "Lambda"
  or
  tag = EllipsisTempVar() and result = "Ellipsis"
}
