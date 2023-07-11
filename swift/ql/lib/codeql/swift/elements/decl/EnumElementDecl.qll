private import codeql.swift.generated.decl.EnumElementDecl
private import codeql.swift.elements.decl.Decl

/**
 * An enum element declaration, for example `enumElement` and `anotherEnumElement` in:
 * ```
 * enum MyEnum {
 *   case enumElement
 *   case anotherEnumElement(Int)
 * }
 * ```
 */
class EnumElementDecl extends Generated::EnumElementDecl {
  override string toString() { result = this.getName() }

  /**
   * Holds if this function is called `funcName` and is a member of a
   * class, struct, extension, enum or protocol called `typeName`.
   */
  cached
  predicate hasQualifiedName(string typeName, string enumElementName) {
    this.getName() = enumElementName and
    exists(Decl d |
      d.asNominalTypeDecl().getFullName() = typeName and
      d.getAMember() = this
    )
  }

  /**
   * Holds if this function is called `funcName` and is a member of a
   * class, struct, extension, enum or protocol called `typeName` in a module
   * called `moduleName`.
   */
  predicate hasQualifiedName(string moduleName, string typeName, string enumElementName) {
    this.hasQualifiedName(typeName, enumElementName) and
    this.getModule().getFullName() = moduleName
  }
}
