private import codeql.swift.generated.pattern.BoolPattern

module Impl {
  class BoolPattern extends Generated::BoolPattern {
    override string toStringImpl() { result = this.getValue().toString() }
  }
}
