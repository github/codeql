// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(ParenTypeRepr x) { toBeTested(x) and not x.isUnknown() }

query predicate getTypeRepr(ParenTypeRepr x, TypeRepr getTypeRepr) {
  toBeTested(x) and not x.isUnknown() and getTypeRepr = x.getTypeRepr()
}
