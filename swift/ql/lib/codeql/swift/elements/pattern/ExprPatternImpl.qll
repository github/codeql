private import codeql.swift.generated.pattern.ExprPattern

module Impl {
  class ExprPattern extends Generated::ExprPattern {
    override string toString() { result = "=~ ..." }
  }
}
