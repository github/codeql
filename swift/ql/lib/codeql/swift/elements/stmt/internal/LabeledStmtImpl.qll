private import codeql.swift.generated.stmt.LabeledStmt

module Impl {
  class LabeledStmt extends Generated::LabeledStmt {
    override string toStringImpl() { result = this.getLabel() + ": ..." }
  }
}
