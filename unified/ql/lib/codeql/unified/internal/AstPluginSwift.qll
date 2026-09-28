overlay[local]
module;

private import unified
private import AstPlugin

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
  override predicate defaultConstructorParameter(ConstructorDeclaration cd, int i, string name) {
    exists(ClassLikeDeclaration cls |
      cd = cls.getAMember() and
      cls.hasModifier("struct") and
      name =
        rank[i](VariableDeclaration decl, int j, string s |
          decl = cls.getMember(j) and
          not decl.hasModifier("static") and
          (
            // if `decl` has an initializer then this parameter has that initializer as a default value
            decl.hasModifier("var")
            or
            decl.hasModifier("let") and
            not exists(decl.getValue())
          ) and
          s = decl.getPattern().(Identifier).getValue()
        |
          s order by j
        )
    )
  }
}
