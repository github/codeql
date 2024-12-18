private import codeql.swift.generated.pattern.BoolPattern

module Impl {
  class BoolPattern extends Generated::BoolPattern {
    override string toString() { result = this.getValue().toString() }
  }
}
