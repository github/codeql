private import codeql.swift.generated.pattern.ExprPattern

class ExprPattern extends ExprPatternBase {
  override string toString() { result = "=~ ..." }
}
