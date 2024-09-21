private import codeql.swift.generated.stmt.BraceStmt

module Impl {
  class BraceStmt extends Generated::BraceStmt {
    AstNode getFirstElement() { result = this.getElement(0) }

    AstNode getLastElement() {
      exists(int i |
        result = this.getElement(i) and
        not exists(this.getElement(i + 1))
      )
    }

    override string toString() { result = "{ ... }" }

    override AstNode getImmediateElement(int index) {
      result =
        rank[index + 1](AstNode element, int i |
          element = super.getImmediateElement(i) and
          not element instanceof VarDecl
        |
          element order by i
        )
    }

    override VarDecl getVariable(int index) {
      result =
        rank[index + 1](VarDecl variable, int i |
          variable = super.getImmediateElement(i)
        |
          variable order by i
        )
    }
  }
}
