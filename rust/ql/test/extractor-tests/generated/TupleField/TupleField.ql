// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(TupleField x) { toBeTested(x) and not x.isUnknown() }

query predicate getAttr(TupleField x, int index, Attr getAttr) {
  toBeTested(x) and not x.isUnknown() and getAttr = x.getAttr(index)
}

query predicate getTypeRepr(TupleField x, TypeRepr getTypeRepr) {
  toBeTested(x) and not x.isUnknown() and getTypeRepr = x.getTypeRepr()
}

query predicate getVisibility(TupleField x, Visibility getVisibility) {
  toBeTested(x) and not x.isUnknown() and getVisibility = x.getVisibility()
}
