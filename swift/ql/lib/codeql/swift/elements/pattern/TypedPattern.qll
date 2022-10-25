private import codeql.swift.generated.pattern.TypedPattern

class TypedPattern extends Generated::TypedPattern {
  override string toString() {
    if exists(this.getSubPattern()) then result = "... as ..." else result = "is ..."
  }
}
