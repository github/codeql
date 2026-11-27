import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest
import TestUtils

query predicate mod(Module m) { toBeTested(m) }

query predicate derive_generated_canonical_paths(TypeItem i, string path) {
  i.getName().getText() = ["ConfigBuilder", "MacroGenerated", "AttributeGenerated"] and
  exists(Crate c | c.getName() = "test" and path = i.getCanonicalPath(c))
}

query predicate resolvePath(PathExt p, ItemNode i) {
  toBeTested(p) and
  not p.isFromMacroExpansion() and
  i = resolvePath(p)
}
