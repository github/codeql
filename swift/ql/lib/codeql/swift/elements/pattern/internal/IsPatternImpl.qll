private import codeql.swift.generated.pattern.IsPattern

module Impl {
  class IsPattern extends Generated::IsPattern {
    override string toString() { result = "... is ..." }
  }
}
