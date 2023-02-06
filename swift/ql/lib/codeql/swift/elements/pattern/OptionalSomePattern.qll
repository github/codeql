private import codeql.swift.generated.pattern.OptionalSomePattern

class OptionalSomePattern extends Generated::OptionalSomePattern {
  override string toString() { result = "let ...?" }
}
