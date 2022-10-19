private import codeql.swift.generated.pattern.NamedPattern

class NamedPattern extends Generated::NamedPattern {
  override string toString() { result = this.getName() }
}
