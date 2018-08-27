import cpp

newtype TTempVariableTag =
  ConditionValueTempVar() or
  ReturnValueTempVar() or
  ThrowTempVar()

string getTempVariableTagId(TTempVariableTag tag) {
  tag = ConditionValueTempVar() and result = "CondVal" or
  tag = ReturnValueTempVar() and result = "Ret" or
  tag = ThrowTempVar() and result = "Throw"
}
