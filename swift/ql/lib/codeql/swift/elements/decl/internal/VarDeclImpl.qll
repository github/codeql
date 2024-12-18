private import codeql.swift.generated.decl.VarDecl
private import codeql.swift.elements.decl.Decl

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A declaration of a variable such as
   * * a local variable in a function:
   * ```
   * func foo() {
   *   var x = 42  // <-
   *   let y = "hello"  // <-
   *   ...
   * }
   * ```
   * * a member of a `struct` or `class`:
   * ```
   * struct S {
   *   var size : Int  // <-
   * }
   * ```
   * * ...
   */
  class VarDecl extends Generated::VarDecl {
    override string toString() { result = this.getName() }
  }

  /**
   * A field declaration. That is, a variable declaration that is a member of a
   * class, struct, enum or protocol.
   */
  class FieldDecl extends VarDecl {
    FieldDecl() { this = any(Decl ctx).getAMember() }

    /**
     * Holds if this field is called `fieldName` and is a member of a
     * class, struct, extension, enum or protocol called `typeName`.
     */
    cached
    predicate hasQualifiedName(string typeName, string fieldName) {
      this.getName() = fieldName and
      exists(Decl d |
        d.asNominalTypeDecl().getFullName() = typeName and
        d.getAMember() = this
      )
    }

    /**
     * Holds if this field is called `fieldName` and is a member of a
     * class, struct, extension, enum or protocol called `typeName` in a module
     * called `moduleName`.
     */
    predicate hasQualifiedName(string moduleName, string typeName, string fieldName) {
      this.hasQualifiedName(typeName, fieldName) and
      this.getModule().getFullName() = moduleName
    }
  }
}
