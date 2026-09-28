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
}
