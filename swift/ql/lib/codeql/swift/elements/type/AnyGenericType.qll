private import codeql.swift.generated.type.AnyGenericType
private import codeql.swift.elements.decl.GenericTypeDecl

class AnyGenericType extends AnyGenericTypeBase {
  string getName() { result = this.getDeclaration().(GenericTypeDecl).getName() }
}
