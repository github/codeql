// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(StructPatFieldList x) { toBeTested(x) and not x.isUnknown() }

query predicate getField(StructPatFieldList x, int index, StructPatField getField) {
  toBeTested(x) and not x.isUnknown() and getField = x.getField(index)
}

query predicate getRestPat(StructPatFieldList x, RestPat getRestPat) {
  toBeTested(x) and not x.isUnknown() and getRestPat = x.getRestPat()
}
