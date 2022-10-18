private import codeql.swift.generated.stmt.BraceStmt

class BraceStmt extends Generated::BraceStmt {
  AstNode getFirstElement() { result = this.getElement(0) }

  AstNode getLastElement() {
    exists(int i |
      result = this.getElement(i) and
      not exists(this.getElement(i + 1))
    )
  }

  override string toString() { result = "{ ... }" }
}
