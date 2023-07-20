private import codeql.swift.generated.decl.TypeDecl
private import codeql.swift.elements.type.AnyGenericType
private import swift

/**
 * A Swift type declaration, for example a class, struct, enum or protocol
 * declaration.
 *
 * Type declarations are distinct from types. A type declaration represents
 * the code that declares a type, for example:
 * ```
 * class MyClass {
 *   ...
 * }
 * ```
 * Not all types have type declarations, for example built-in types do not
 * have type declarations.
 */
class TypeDecl extends Generated::TypeDecl {
  override string toString() { result = this.getName() }

  /**
   * Gets the declaration of the `index`th base type of this type declaration (0-based).
   */
  TypeDecl getBaseTypeDecl(int i) { result = this.getBaseType(i).(AnyGenericType).getDeclaration() }

  /**
   * Gets the declaration of any of the base types of this type declaration.
   */
  TypeDecl getABaseTypeDecl() { result = this.getBaseTypeDecl(_) }

  /**
   * Gets a declaration that has this type as its `index`th base type.
   *
   * DEPRECATED: The index is not very meaningful here. Use `getADerivedTypeDecl` or `getBaseTypeDecl`.
   */
  deprecated TypeDecl getDerivedTypeDecl(int i) { result.getBaseTypeDecl(i) = this }

  /**
   * Gets the declaration of any type derived from this type declaration.
   */
  TypeDecl getADerivedTypeDecl() { result.getBaseTypeDecl(_) = this }

  /**
   * Gets the full name of this `TypeDecl`. For example in:
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
  cached
  string getFullName() {
    not this.getEnclosingDecl() instanceof TypeDecl and
    not this.getEnclosingDecl() instanceof ExtensionDecl and
    result = this.getName()
    or
    result = this.getEnclosingDecl().(TypeDecl).getFullName() + "." + this.getName()
    or
    result =
      this.getEnclosingDecl().(ExtensionDecl).getExtendedTypeDecl().getFullName() + "." +
        this.getName()
  }
}
