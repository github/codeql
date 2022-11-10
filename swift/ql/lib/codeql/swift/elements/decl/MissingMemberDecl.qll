private import codeql.swift.generated.decl.MissingMemberDecl

class MissingMemberDecl extends Generated::MissingMemberDecl {
  override string toString() { result = this.getName() + " (missing)" }
}
