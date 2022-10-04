private import codeql.swift.generated.decl.TypeDecl
private import codeql.swift.generated.type.Type
private import codeql.swift.elements.type.AnyGenericType

class TypeDecl extends TypeDeclBase {
  override string toString() { result = this.getName() }

  TypeDecl getBaseTypeDecl(int i) { result = this.getBaseType(i).(AnyGenericType).getDeclaration() }

  TypeDecl getABaseTypeDecl() { result = this.getBaseTypeDecl(_) }

  TypeDecl getDerivedTypeDecl(int i) { result.getBaseTypeDecl(i) = this }

  TypeDecl getADerivedTypeDecl() { result = this.getDerivedTypeDecl(_) }
}
