import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest
import TestUtils

query predicate mod(Module m) { toBeTested(m) }

query predicate resolvePath(PathExt p, ItemNode i) {
  toBeTested(p) and
  not p.isFromMacroExpansion() and
  i = resolvePath(p)
}
