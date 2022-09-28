private import codeql.swift.generated.pattern.BoolPattern

class BoolPattern extends BoolPatternBase {
  override string toString() { result = this.getValue().toString() }
}
