private import codeql.swift.generated.pattern.ParenPattern

module Impl {
  class ParenPattern extends Generated::ParenPattern {
    final override Pattern getResolveStep() { result = this.getImmediateSubPattern() }

    override string toString() { result = "(...)" }
  }
}
