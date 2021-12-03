import cpp
import semmle.code.cpp.Print

abstract class CheckCall extends FunctionCall {
  abstract string getActualString();

  final string getExpectedString() {
    exists(int lastArgIndex |
      lastArgIndex = getNumberOfArguments() - 1 and
      (
        result = getArgument(lastArgIndex).getValue()
        or
        not exists(getArgument(lastArgIndex).getValue()) and result = "<missing>"
      )
    )
  }

  abstract string explain();
}

class CheckTypeCall extends CheckCall {
  CheckTypeCall() {
    getTarget().(FunctionTemplateInstantiation).getTemplate().hasGlobalName("check_type")
  }

  override string getActualString() {
    result = getTypeIdentityString(getSpecifiedType())
    or
    not exists(getTypeIdentityString(getSpecifiedType())) and result = "<missing>"
  }

  override string explain() { result = getSpecifiedType().explain() }

  final Type getSpecifiedType() { result = getTarget().getTemplateArgument(0) }
}

class CheckFuncCall extends CheckCall {
  CheckFuncCall() {
    getTarget().(FunctionTemplateInstantiation).getTemplate().hasGlobalName("check_func")
  }

  override string getActualString() {
    result = getIdentityString(getSpecifiedFunction())
    or
    not exists(getIdentityString(getSpecifiedFunction())) and result = "<missing>"
  }

  override string explain() { result = getSpecifiedFunction().toString() }

  final Function getSpecifiedFunction() { result = getArgument(0).(FunctionAccess).getTarget() }
}

class CheckVarCall extends CheckCall {
  CheckVarCall() {
    getTarget().(FunctionTemplateInstantiation).getTemplate().hasGlobalName("check_var")
  }

  override string getActualString() {
    result = getIdentityString(getSpecifiedVariable())
    or
    not exists(getIdentityString(getSpecifiedVariable())) and result = "<missing>"
  }

  override string explain() { result = getSpecifiedVariable().toString() }

  final Variable getSpecifiedVariable() { result = getArgument(0).(VariableAccess).getTarget() }
}

bindingset[s]
private string normalizeLambdas(string s) {
  result = s.regexpReplaceAll("line \\d+, col\\. \\d+", "line ?, col. ?")
}

from CheckCall call, string expected, string actual
where
  expected = call.getExpectedString() and
  actual = normalizeLambdas(call.getActualString()) and
  expected != actual
select call, "Expected: '" + expected + "'", "Actual: '" + actual + "'", call.explain()
