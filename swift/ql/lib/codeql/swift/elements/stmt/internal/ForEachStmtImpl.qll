private import codeql.swift.generated.stmt.ForEachStmt

module Impl {
  class ForEachStmt extends Generated::ForEachStmt {
    override string toString() {
      if this.hasWhere()
      then result = "for ... in ... where ... { ... }"
      else result = "for ... in ... { ... }"
    }

    /**
     * Gets the sequence which this statement is iterating over.
     */
    final Expr getSequence() { result = this.getIteratorVar().getInit(0) }
  }
}
