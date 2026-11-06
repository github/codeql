overlay[local?]
module;

private import unified
private import AstPlugin

private Stmt assumeThenCompilationBranches(Stmt stmt) {
  // For now we simply assume that the `then` branch is always taken for
  // conditional compilation blocks. This means that a parameter index results
  // in a unique parameter type.
  if stmt.(IfExpr).isConditionalCompilation()
  then result = assumeThenCompilationBranches(stmt.(IfExpr).getThen().(Block).getAStmt())
  else result = stmt
}

/**
 * Holds if a constructor declaration `cd` of a struct has a parameter for the
 * field `decl` with name `name` and default value `hasDefault`.
 */
private predicate structHasParameterForField(
  ConstructorDeclaration cd, VariableDeclaration decl, string name, boolean hasDefault
) {
  exists(ClassLikeDeclaration struct |
    struct.hasModifier("struct") and
    cd = struct.getAMember() and
    decl = assumeThenCompilationBranches(struct.getADirectMember()) and
    not decl.hasModifier("static") and
    name = decl.getPattern().(Identifier).getValue()
  |
    // if `decl` has an initializer or `Optional` type then the parameter has a default value
    decl.hasModifier("var") and
    if
      exists(decl.getValue())
      or
      // we could make this more precise using static name binding, but for now we
      // use a simpler approach to avoid the dependency on static name binding
      decl.getType().(GenericTypeExpr).getBase().(Identifier).getValue() = "Optional"
    then hasDefault = true
    else hasDefault = false
    or
    decl.hasModifier("let") and
    not exists(decl.getValue()) and
    hasDefault = false
  )
}

private class AstPluginSwift extends AstPlugin {
  bindingset[f]
  override string getFunctionDeclarationKeyword(FunctionDeclaration f) {
    exists(f) and result = "func"
  }

  bindingset[c]
  override string getConstructorDeclarationKeyword(ConstructorDeclaration c) {
    c.hasModifier(result) and
    result = "convenience"
  }

  override string getClassLikeDeclarationKeyword(ClassLikeDeclaration cls) {
    cls.hasModifier(result) and
    result in ["class", "struct", "enum", "actor", "extension", "protocol"]
  }

  override string getVariableDeclarationKeyword(VariableDeclaration decl) {
    decl.hasModifier(result) and
    result in ["var", "let"]
  }

  bindingset[cd]
  override predicate defaultConstructorParameter(
    ConstructorDeclaration cd, int i, string name, boolean hasDefault
  ) {
    name =
      rank[i](VariableDeclaration decl, string s |
        structHasParameterForField(cd, decl, s, _)
      |
        // Due to conditional compilation blocks, we cannot simply order
        // parameters by their parent index. Instead we order by their location.
        s
        order by
          decl.getLocation().getStartLine(), decl.getLocation().getStartColumn(),
          decl.getParentIndex()
      ) and
    structHasParameterForField(cd, _, name, hasDefault)
  }

  bindingset[cd]
  override predicate defaultConstructorParameterType(ConstructorDeclaration cd, int i, AstNode type) {
    exists(VariableDeclaration decl, string name |
      this.defaultConstructorParameter(cd, i, name, _) and
      structHasParameterForField(cd, decl, name, _) and
      type = decl.getType()
    )
  }
}
