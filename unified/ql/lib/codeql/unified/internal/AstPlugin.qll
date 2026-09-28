overlay[local]
module;

private import unified
private import codeql.util.Unit

private module Plugins {
  private import AstPluginSwift
}

class AstPlugin extends Unit {
  bindingset[f]
  string getFunctionDeclarationKeyword(FunctionDeclaration f) { none() }

  bindingset[c]
  string getConstructorDeclarationKeyword(ConstructorDeclaration c) { none() }

  bindingset[cls]
  string getClassLikeDeclarationKeyword(ClassLikeDeclaration cls) { none() }

  bindingset[decl]
  string getVariableDeclarationKeyword(VariableDeclaration decl) { none() }

  /**
   * Holds if the default constructor `cd` needs a parameter at index `i` with
   * the given name. `i = 0` is reserved for the implicit receiver parameter.
   */
  bindingset[cd]
  predicate defaultConstructorParameter(ConstructorDeclaration cd, int i, string name) { none() }
}

bindingset[f]
string getFunctionDeclarationKeyword(FunctionDeclaration f) {
  result = any(AstPlugin p).getFunctionDeclarationKeyword(f)
}

bindingset[c]
string getConstructorDeclarationKeyword(ConstructorDeclaration c) {
  result = any(AstPlugin p).getConstructorDeclarationKeyword(c)
}

bindingset[cls]
string getClassLikeDeclarationKeyword(ClassLikeDeclaration cls) {
  result = any(AstPlugin p).getClassLikeDeclarationKeyword(cls)
}

bindingset[decl]
string getVariableDeclarationKeyword(VariableDeclaration decl) {
  result = any(AstPlugin p).getVariableDeclarationKeyword(decl)
}

bindingset[cd]
predicate defaultConstructorParameter(ConstructorDeclaration cd, int i, string name) {
  any(AstPlugin p).defaultConstructorParameter(cd, i, name)
}
