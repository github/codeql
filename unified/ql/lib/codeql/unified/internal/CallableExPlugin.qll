private import unified
private import codeql.util.Unit

private module Plugins {
  private import codeql.unified.internal.CallableExPluginSwift
}

/** Extension point for language-specific inputs to `CallableEx.qll`. */
class CallableExPlugin extends Unit {
  /**
   * Holds if the class-like declaration `cls` may have a constructor with the
   * given name.
   */
  predicate mayHaveConstructor(ClassLikeDeclaration cls, string name) { none() }

  /**
   * Holds if a default constructor for `cls` would need to have a parameter
   * at index `i` with the given name. `i = 0` should be the implicit receiver
   * parameter.
   */
  bindingset[cls]
  predicate defaultConstructorParameter(ClassLikeDeclaration cls, int i, string name) { none() }
}

predicate mayHaveConstructor(ClassLikeDeclaration cls, string name) {
  any(CallableExPlugin p).mayHaveConstructor(cls, name)
}

bindingset[cls]
predicate defaultConstructorParameter(ClassLikeDeclaration cls, int i, string name) {
  any(CallableExPlugin p).defaultConstructorParameter(cls, i, name)
}
