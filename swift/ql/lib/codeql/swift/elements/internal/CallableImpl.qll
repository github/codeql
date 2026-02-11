private import codeql.swift.generated.Callable
private import codeql.swift.elements.AstNode
private import codeql.swift.elements.decl.Decl

module Impl {
  class Callable extends Generated::Callable {
    /**
     * Holds if this Callable is a function named `funcName`.
     */
    predicate hasName(string funcName) { this.getName() = funcName }

    /**
     * Holds if this Callable is a function named `funcName` defined in a module
     * called `moduleName`.
     */
    predicate hasName(string moduleName, string funcName) {
      this.hasName(funcName) and
      this.(Decl).getModule().getFullName() = moduleName
    }
  }
}
