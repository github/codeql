private import codeql.swift.generated.decl.OperatorDecl

class OperatorDecl extends Generated::OperatorDecl {
  override string toString() { result = this.getName() }
}
