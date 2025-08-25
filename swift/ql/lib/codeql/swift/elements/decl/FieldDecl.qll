private import VarDecl

/**
 * A field declaration. That is, a variable declaration that is a member of a
 * class, struct, enum or protocol.
 */
final class FieldDecl extends VarDecl {
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
