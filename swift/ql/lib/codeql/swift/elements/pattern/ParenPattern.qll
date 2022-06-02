private import codeql.swift.generated.pattern.ParenPattern

class ParenPattern extends ParenPatternBase {
  final override Pattern getResolveStep() { paren_patterns(this, result) }

  override string toString() { result = "(...)" }
}
