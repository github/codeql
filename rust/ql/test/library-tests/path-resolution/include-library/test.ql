import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest

query predicate exportedMacro(string crateName, int definitions) {
  exists(CrateItemNode c |
    crateName = c.getName() and
    c.fromSource() and
    definitions = count(MacroRules m | m = c.getASuccessor("included_library_export"))
  )
}
