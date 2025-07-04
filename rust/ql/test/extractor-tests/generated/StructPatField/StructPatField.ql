// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(StructPatField x) { toBeTested(x) and not x.isUnknown() }

query predicate getAttr(StructPatField x, int index, Attr getAttr) {
  toBeTested(x) and not x.isUnknown() and getAttr = x.getAttr(index)
}

query predicate getIdentifier(StructPatField x, NameRef getIdentifier) {
  toBeTested(x) and not x.isUnknown() and getIdentifier = x.getIdentifier()
}

query predicate getPat(StructPatField x, Pat getPat) {
  toBeTested(x) and not x.isUnknown() and getPat = x.getPat()
}
