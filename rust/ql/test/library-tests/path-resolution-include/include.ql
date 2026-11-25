import rust
import codeql.rust.internal.PathResolution
import utils.test.PathResolutionInlineExpectationsTest
import TestUtils

query predicate resolvePath(PathExt p, ItemNode i) {
  toBeTested(p) and
  not p.isFromMacroExpansion() and
  i = resolvePath(p)
}

query predicate includedModule(string name, string file) {
  exists(Module m, SourceFile f |
    m.isInMacroExpansion() and
    fileImport(m, f) and
    name = m.getName().getText() and
    file = f.getFile().getRelativePath()
  )
}

query predicate includeTokens(string text) {
  exists(MacroCall call |
    toBeTested(call) and
    call.getPath().getText() = "include" and
    text = call.getTokenTree().getText()
  )
}
