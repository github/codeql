private import codeql.swift.generated.decl.TypeDecl
private import codeql.swift.elements.type.AnyGenericType
private import swift

module Impl {
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
     * Gets the `index`th base type of this type declaration (0-based).
     *
     * This is the same as `getImmediateInheritedType`.
     * DEPRECATED: either use `getImmediateInheritedType` or unindexed `getABaseType`.
     */
    deprecated Type getImmediateBaseType(int index) {
      result = this.getImmediateInheritedType(index)
    }

    /**
     * Gets the `index`th base type of this type declaration (0-based).
     * This is the same as `getInheritedType`.
     * DEPRECATED: use `getInheritedType` or unindexed `getABaseType`.
     */
    deprecated Type getBaseType(int index) { result = this.getInheritedType(index) }

    /**
     * Gets any of the base types of this type declaration. Expands protocols added in
     * extensions and expands type aliases. For example in the following code, `B` has
     * base type `A`:
     * ```
     * typealias A_alias = A
     *
     * class B : A_alias {}
     * ```
     */
    Type getABaseType() {
      // direct base type
      result = this.getAnInheritedType().getUnderlyingType()
      or
      // protocol added in an extension of the type
      exists(ExtensionDecl ed |
        ed.getExtendedTypeDecl() = this and
        ed.getAProtocol().getType() = result
      )
    }

    /**
     * Gets the declaration of the `index`th base type of this type declaration (0-based).
     * DEPRECATED: The index is not very meaningful here. Use `getABaseTypeDecl`.
     */
    deprecated TypeDecl getBaseTypeDecl(int i) {
      result = this.getBaseType(i).(AnyGenericType).getDeclaration()
    }

    /**
     * Gets the declaration of any of the base types of this type declaration. Expands
     * protocols added in extensions and expands type aliases. For example in the following
     * code, `B` has base type `A`.
     * ```
     * typealias A_alias = A
     *
     * class B : A_alias {}
     * ```
     */
    TypeDecl getABaseTypeDecl() { result = this.getABaseType().(AnyGenericType).getDeclaration() }

    /**
     * Gets the declaration of any type derived from this type declaration. Expands protocols
     * added in extensions and expands type aliases. For example in the following code, `B`
     * is derived from `A`.
     * ```
     * typealias A_alias = A
     *
     * class B : A_alias {}
     * ```
     */
    TypeDecl getADerivedTypeDecl() { result.getABaseTypeDecl() = this }

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
      not count(this.getEnclosingDecl().(ExtensionDecl).getExtendedTypeDecl()) = 1 and
      result = this.getName()
      or
      result = this.getEnclosingDecl().(TypeDecl).getFullName() + "." + this.getName()
      or
      result =
        unique(NominalTypeDecl td |
            td = this.getEnclosingDecl().(ExtensionDecl).getExtendedTypeDecl()
          ).getFullName() + "." + this.getName()
    }
  }
}
