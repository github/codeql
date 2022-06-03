private import codeql.swift.generated.pattern.NamedPattern

class NamedPattern extends NamedPatternBase {
  override string toString() { result = this.getName() }
}
