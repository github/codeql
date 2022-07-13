private import codeql.swift.generated.type.NominalType
private import codeql.swift.elements.decl.NominalTypeDecl

class NominalType extends NominalTypeBase {
  NominalType getABaseType() { result = this.getDeclaration().(NominalTypeDecl).getABaseType() }

  NominalType getADerivedType() { result.getABaseType() = this }
}
