private import unified
private import codeql.unified.internal.CallableExPlugin

class CallableExPluginSwift extends CallableExPlugin {
  override predicate mayHaveConstructor(ClassLikeDeclaration cls, string name) {
    cls.hasModifier(["actor", "class", "struct"]) and
    name = "init"
  }

  bindingset[c]
  override predicate constructorPreventsImplicit(ConstructorDeclaration c) {
    not c.hasModifier("convenience")
  }

  bindingset[cls]
  override predicate defaultConstructorParameter(ClassLikeDeclaration cls, int i, string name) {
    i = 0 and
    name = "self"
    or
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
  }

  bindingset[cls]
  override predicate mayInheritConstructor(ClassLikeDeclaration cls) { any() }
}
