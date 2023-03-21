private import codeql.swift.generated.decl.TypeDecl
private import codeql.swift.elements.type.AnyGenericType
private import swift

class TypeDecl extends Generated::TypeDecl {
  override string toString() { result = this.getName() }

  TypeDecl getBaseTypeDecl(int i) { result = this.getBaseType(i).(AnyGenericType).getDeclaration() }

  TypeDecl getABaseTypeDecl() { result = this.getBaseTypeDecl(_) }

  TypeDecl getDerivedTypeDecl(int i) { result.getBaseTypeDecl(i) = this }

  TypeDecl getADerivedTypeDecl() { result = this.getDerivedTypeDecl(_) }

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
    result = this.getEnclosingDecl().(ExtensionDecl).getExtendedTypeDecl().getFullName() + "." + this.getName()
  }
}
