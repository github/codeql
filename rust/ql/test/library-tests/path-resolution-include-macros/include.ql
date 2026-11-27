import rust
import codeql.rust.internal.PathResolution
import TestUtils

query predicate builtinIncludeArgument(string text) {
  exists(MacroCall call |
    toBeTested(call) and
    call.isBuiltinInclude() and
    text = call.getTokenTree().getText()
  )
}

query predicate moduleImport(string name, string source, string imported) {
  exists(Module m |
    m.isInMacroExpansion() and
    toBeTested(m) and
    name = m.getName().getText() and
    source = m.getFile().getRelativePath()
  |
    if exists(SourceFile f | fileImport(m, f))
    then
      exists(SourceFile f |
        fileImport(m, f) and
        imported = f.getFile().getRelativePath()
      )
    else imported = "<unresolved>"
  )
}

query predicate functionTarget(string name, string file) {
  exists(CallExpr call, Function f |
    call.getFile().getRelativePath() = "main.rs" and
    f = resolvePath(call.getFunction().(PathExpr).getPath()) and
    name = f.getName().getText() and
    file = f.getFile().getRelativePath()
  )
}
