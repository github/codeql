private import codeql.swift.generated.decl.EnumElementDecl
private import codeql.swift.elements.decl.EnumDecl

module Impl {
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
     * Holds if this enum element declaration is called `enumElementName` and is a member of an
     * enum called `enumName`.
     */
    cached
    predicate hasQualifiedName(string enumName, string enumElementName) {
      this.getName() = enumElementName and
      exists(EnumDecl d |
        d.getFullName() = enumName and
        d.getAMember() = this
      )
    }

    /**
     * Holds if this enum element declaration is called `enumElementName` and is a member of an
     * enumcalled `enumName` in a module called `moduleName`.
     */
    predicate hasQualifiedName(string moduleName, string enumName, string enumElementName) {
      this.hasQualifiedName(enumName, enumElementName) and
      this.getModule().getFullName() = moduleName
    }
  }
}
