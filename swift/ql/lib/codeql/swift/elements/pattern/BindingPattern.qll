private import codeql.swift.generated.pattern.BindingPattern

class BindingPattern extends BindingPatternBase {
  override string toString() { result = "let ..." }
}
