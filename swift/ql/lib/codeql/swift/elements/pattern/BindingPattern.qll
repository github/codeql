private import codeql.swift.generated.pattern.BindingPattern

class BindingPattern extends Generated::BindingPattern {
  final override Pattern getResolveStep() { result = getImmediateSubPattern() }

  override string toString() { result = "let ..." }
}
