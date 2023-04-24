private import codeql.swift.generated.type.NominalType
private import codeql.swift.elements.decl.NominalTypeDecl
private import codeql.swift.elements.type.Type

class NominalType extends Generated::NominalType {
  override Type getABaseType() { result = this.getDeclaration().(NominalTypeDecl).getABaseType() }

  NominalType getADerivedType() { result.getABaseType() = this }

  /**
   * Gets the full name of this `NominalType`. For example in:
   * ```swift
   * struct A {
   *   struct B {
   *     // ...
   *   }
   * }
   * ```
   * The name and full name of `A` is `A`. The name of `B` is `B`, but the
   * full name of `B` is `A.B`.
   */
  string getFullName() { result = this.getDeclaration().(NominalTypeDecl).getFullName() }
}
