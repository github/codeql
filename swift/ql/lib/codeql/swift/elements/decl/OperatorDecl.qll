private import codeql.swift.generated.decl.OperatorDecl

class OperatorDecl extends OperatorDeclBase {
  override string toString() { result = this.getName() }
}
