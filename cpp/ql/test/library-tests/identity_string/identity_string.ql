import cpp
import semmle.code.cpp.Print

abstract class CheckCall extends FunctionCall {
  abstract string getActualString();

  final string getExpectedString() {
    exists(int lastArgIndex |
      lastArgIndex = this.getNumberOfArguments() - 1 and
      (
        result = this.getArgument(lastArgIndex).getValue()
        or
        not exists(this.getArgument(lastArgIndex).getValue()) and result = "<missing>"
      )
    )
  }

  abstract string explain();
}

class CheckTypeCall extends CheckCall {
  CheckTypeCall() {
    this.getTarget().(FunctionTemplateInstantiation).getTemplate().hasGlobalName("check_type")
  }

  override string getActualString() {
    result = getTypeIdentityString(this.getSpecifiedType())
    or
    not exists(getTypeIdentityString(this.getSpecifiedType())) and result = "<missing>"
  }

  override string explain() { result = this.getSpecifiedType().explain() }

  final Type getSpecifiedType() { result = this.getTarget().getTemplateArgument(0) }
}

class CheckFuncCall extends CheckCall {
  CheckFuncCall() {
    this.getTarget().(FunctionTemplateInstantiation).getTemplate().hasGlobalName("check_func")
  }

  override string getActualString() {
    result = getIdentityString(this.getSpecifiedFunction())
    or
    not exists(getIdentityString(this.getSpecifiedFunction())) and result = "<missing>"
  }

  override string explain() { result = this.getSpecifiedFunction().toString() }

  final Function getSpecifiedFunction() {
    result = this.getArgument(0).(FunctionAccess).getTarget()
  }
}

class CheckVarCall extends CheckCall {
  CheckVarCall() {
    this.getTarget().(FunctionTemplateInstantiation).getTemplate().hasGlobalName("check_var")
  }

  override string getActualString() {
    result = getIdentityString(this.getSpecifiedVariable())
    or
    not exists(getIdentityString(this.getSpecifiedVariable())) and result = "<missing>"
  }

  override string explain() { result = this.getSpecifiedVariable().toString() }

  final Variable getSpecifiedVariable() {
    result = this.getArgument(0).(VariableAccess).getTarget()
  }
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
