import rust
import codeql.rust.internal.PathResolution
import codeql.rust.controlflow.ControlFlowGraph
import codeql.rust.elements.SourceFile

query predicate generatedFunction(boolean fromSource, int cfgNodes, string canonicalPath) {
  exists(Function f |
    f.getName().getText() = ["generated_function", "child_function", "grandchild_function"] and
    (if f.fromSource() then fromSource = true else fromSource = false) and
    cfgNodes = count(CfgNode n | n.getAstNode().getEnclosingCallable() = f) and
    canonicalPath = f.getCanonicalPath()
  )
}

query predicate rootReference(string source, string target) {
  exists(CallExpr call |
    source = call.getEnclosingCallable().(Function).getName().getText() and
    source = ["generated_function", "generated_alias", "child_function", "grandchild_function"] and
    target = call.getResolvedTarget().(Function).getName().getText()
  )
}

query predicate macroReference(string target) {
  exists(CallExpr call |
    call.fromSource() and
    call.isInMacroExpansion() and
    call.getFunction().(PathExpr).getPath().getQualifier().getText() = "$crate" and
    target = call.getResolvedTarget().(Function).getName().getText()
  )
}

query predicate exportedMacro(string name, int definitions) {
  exists(CrateItemNode c |
    c.getName() = "main" and
    name = "generated_export" and
    definitions = count(MacroRules m | m = c.getASuccessor(name))
  )
}

query predicate includedInitializerScope(string name, string scopeFile) {
  exists(CallExpr call, AstNode initializer |
    initializer = call.getParentNode*() and
    (initializer instanceof Const or initializer instanceof Static) and
    (
      name = initializer.(Const).getName().getText()
      or
      name = initializer.(Static).getName().getText()
    ) and
    name = ["INCLUDED_CONST", "INCLUDED_STATIC"] and
    call.getResolvedTarget().(Function).getName().getText() = "root_const" and
    scopeFile = call.getEnclosingCfgScope().(SourceFile).getFile().getRelativePath()
  )
}
