private import codeql.swift.generated.pattern.TypedPattern

class TypedPattern extends TypedPatternBase {
  override string toString() {
    if exists(this.getSubPattern()) then result = "... as ..." else result = "is ..."
  }
}
