private import codeql.swift.generated.pattern.OptionalSomePattern

class OptionalSomePattern extends OptionalSomePatternBase {
  override string toString() { result = "let ...?" }
}
