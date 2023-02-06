private import codeql.swift.generated.pattern.EnumElementPattern

class EnumElementPattern extends Generated::EnumElementPattern {
  override string toString() {
    if this.hasSubPattern()
    then result = "." + this.getElement().toString() + "(...)"
    else result = "." + this.getElement().toString()
  }
}
