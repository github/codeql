private import codeql.swift.generated.pattern.AnyPattern

module Impl {
  class AnyPattern extends Generated::AnyPattern {
    override string toString() { result = "_" }
  }
}
