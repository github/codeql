// generated by codegen/codegen.py, do not edit
import codeql.swift.elements
import TestUtils

query predicate instances(CaseLabelItem x, string getPattern__label, Pattern getPattern) {
  toBeTested(x) and
  not x.isUnknown() and
  getPattern__label = "getPattern:" and
  getPattern = x.getPattern()
}

query predicate getGuard(CaseLabelItem x, Expr getGuard) {
  toBeTested(x) and not x.isUnknown() and getGuard = x.getGuard()
}
