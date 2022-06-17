private import codeql.swift.generated.decl.DestructorDecl

class DestructorDecl extends DestructorDeclBase {
  override string toString() { result = "deinit" }
}
