overlay[local?]
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
   * Holds if `ident` accesses an implicit function-expression parameter at
   * index `n`.
   *
   * For instance:
   * - In Kotlin `it` accesses an implicit parameter at index 0.
   * - In Swift `$1` accesses an implicit parameter at index 1.
   * - In Ruby `_2` accesses an implicit parameter at index 2.
   */
  predicate implicitFunctionExprParamAccess(Identifier ident, int n) { none() }

  /**
   * Holds if the default constructor `cd` needs a parameter at index `i` with
   * the given name. `hasDefault` indicates whether the parameter has a default
   * value.
   *
   * `i = 0` is reserved for the implicit receiver parameter.
   */
  bindingset[cd]
  predicate defaultConstructorParameter(
    ConstructorDeclaration cd, int i, string name, boolean hasDefault
  ) {
    none()
  }

  /**
   * Holds if the type of the `i`th parameter of the default constructor `cd`
   * is `type`.
   */
  bindingset[cd]
  predicate defaultConstructorParameterType(ConstructorDeclaration cd, int i, AstNode type) {
    none()
  }
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

/**
 * Gets the name of the `n`th implicit parameter of function expression `fe`.
 */
string getImplicitFunctionExprParamName(FunctionExpr fe, int n) {
  // For now we assume that an implicit parameter access always belongs to its
  // enclosing function expression. This is correct for Swift but not in the
  // following Kotlin example:
  // ```kotlin
  // listOf(1, 2).map { listOf(3, 4).map { inner -> it + inner } }
  // ```
  // Here `it` refers to the outer function expression. The inner function
  // expression has an explicit parameter list so it does not introduce `it`.
  exists(Identifier ident |
    any(AstPlugin p).implicitFunctionExprParamAccess(ident, n) and
    fe = ident.getEnclosingCallable() and
    result = ident.getValue()
  )
}

bindingset[cd]
predicate defaultConstructorParameter(
  ConstructorDeclaration cd, int i, string name, boolean hasDefault
) {
  any(AstPlugin p).defaultConstructorParameter(cd, i, name, hasDefault)
}

bindingset[cd]
predicate defaultConstructorParameterType(ConstructorDeclaration cd, int i, AstNode type) {
  any(AstPlugin p).defaultConstructorParameterType(cd, i, type)
}
