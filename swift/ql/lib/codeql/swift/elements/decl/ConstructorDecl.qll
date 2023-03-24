private import codeql.swift.generated.decl.ConstructorDecl
private import codeql.swift.elements.decl.MethodDecl

/**
 * An initializer of a class, struct, enum or protocol.
 */
class ConstructorDecl extends Generated::ConstructorDecl, MethodDecl {
  override string toString() { result = this.getSelfParam().getType() + "." + super.toString() }
}
