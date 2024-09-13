private import codeql.swift.generated.pattern.BindingPattern

module Impl {
  class BindingPattern extends Generated::BindingPattern {
    final override Pattern getResolveStep() { result = this.getImmediateSubPattern() }

    override string toString() { result = "let ..." }
  }
}
