private import codeql.swift.generated.pattern.ParenPattern

class ParenPattern extends Generated::ParenPattern {
  final override Pattern getResolveStep() { result = getImmediateSubPattern() }

  override string toString() { result = "(...)" }
}
