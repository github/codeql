// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(FormatArgument x, string getParent__label, Format getParent) {
  toBeTested(x) and
  not x.isUnknown() and
  getParent__label = "getParent:" and
  getParent = x.getParent()
}

query predicate getVariable(FormatArgument x, FormatTemplateVariableAccess getVariable) {
  toBeTested(x) and not x.isUnknown() and getVariable = x.getVariable()
}
