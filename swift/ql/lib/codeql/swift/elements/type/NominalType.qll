private import codeql.swift.generated.type.NominalType
private import codeql.swift.elements.decl.NominalTypeDecl
private import codeql.swift.elements.type.Type

class NominalType extends Generated::NominalType {
  override Type getABaseType() { result = this.getDeclaration().(NominalTypeDecl).getABaseType() }

  NominalType getADerivedType() { result.getABaseType() = this }
}
