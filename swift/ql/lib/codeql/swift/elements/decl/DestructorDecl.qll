private import codeql.swift.generated.decl.DestructorDecl
private import codeql.swift.elements.decl.MethodDecl

/**
 * A deinitializer of a class.
 */
class DestructorDecl extends Generated::DestructorDecl, MethodDecl {
  override string toString() { result = this.getSelfParam().getType() + "." + super.toString() }
}
