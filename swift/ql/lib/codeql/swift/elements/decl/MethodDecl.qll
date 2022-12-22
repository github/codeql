private import swift
private import codeql.swift.elements.decl.DeclWithMembers

/**
 * A function that is a member of a class, struct, enum or protocol.
 */
class MethodDecl extends AbstractFunctionDecl {
  MethodDecl() { this = any(DeclWithMembers decl).getAMember() }

  /**
   * Holds if this function is called `funcName` and its a member of a
   * class, struct, extension, enum or protocol call `typeName`.
   */
  cached
  predicate hasQualifiedName(string typeName, string funcName) {
    this.getName() = funcName and
    this.getDeclaringTypeDecl().getFullName() = typeName
  }

  /**
   * Holds if this function is called `funcName` and its a member of a
   * class, struct, extension, enum or protocol call `typeName` in a module
   * called `moduleName`.
   */
  predicate hasQualifiedName(string moduleName, string typeName, string funcName) {
    this.hasQualifiedName(typeName, funcName) and
    this.getModule().getFullName() = moduleName
  }
}
