// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

query predicate instances(ExternCrate x) { toBeTested(x) and not x.isUnknown() }

query predicate getExtendedCanonicalPath(ExternCrate x, string getExtendedCanonicalPath) {
  toBeTested(x) and not x.isUnknown() and getExtendedCanonicalPath = x.getExtendedCanonicalPath()
}

query predicate getCrateOrigin(ExternCrate x, string getCrateOrigin) {
  toBeTested(x) and not x.isUnknown() and getCrateOrigin = x.getCrateOrigin()
}

query predicate getAttributeMacroExpansion(ExternCrate x, MacroItems getAttributeMacroExpansion) {
  toBeTested(x) and
  not x.isUnknown() and
  getAttributeMacroExpansion = x.getAttributeMacroExpansion()
}

query predicate getAttr(ExternCrate x, int index, Attr getAttr) {
  toBeTested(x) and not x.isUnknown() and getAttr = x.getAttr(index)
}

query predicate getIdentifier(ExternCrate x, NameRef getIdentifier) {
  toBeTested(x) and not x.isUnknown() and getIdentifier = x.getIdentifier()
}

query predicate getRename(ExternCrate x, Rename getRename) {
  toBeTested(x) and not x.isUnknown() and getRename = x.getRename()
}

query predicate getVisibility(ExternCrate x, Visibility getVisibility) {
  toBeTested(x) and not x.isUnknown() and getVisibility = x.getVisibility()
}
