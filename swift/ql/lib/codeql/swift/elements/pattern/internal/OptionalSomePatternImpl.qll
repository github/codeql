private import codeql.swift.generated.pattern.OptionalSomePattern

module Impl {
  class OptionalSomePattern extends Generated::OptionalSomePattern {
    override string toString() { result = "let ...?" }
  }
}
