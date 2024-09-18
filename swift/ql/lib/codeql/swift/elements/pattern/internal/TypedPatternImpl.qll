private import codeql.swift.generated.pattern.TypedPattern

module Impl {
  class TypedPattern extends Generated::TypedPattern {
    override string toString() {
      if exists(this.getSubPattern()) then result = "... as ..." else result = "is ..."
    }
  }
}
