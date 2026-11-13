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

query predicate includedMacroExports(string name, int definitions) {
  exists(CrateItemNode c |
    c.getName() = "main" and
    c.getSourceFile().getFile().getRelativePath() = "main.rs" and
    name = ["included_export", "disabled_export", "disabled_child_export"] and
    definitions = count(MacroRules m | m = c.getASuccessor(name))
  )
}
