private import codeql.swift.generated.pattern.EnumElementPattern
private import codeql.swift.elements.pattern.TuplePattern

module Impl {
  class EnumElementPattern extends Generated::EnumElementPattern {
    /**
     * Gets the `i`th element (0-based) of this enum element's tuple
     * sub-pattern, if any, or the sub-pattern itself if it is not a tuple pattern.
     */
    Pattern getSubPattern(int i) {
      result = this.getSubPattern().(TuplePattern).getElement(i)
      or
      not this.getSubPattern() instanceof TuplePattern and
      result = this.getSubPattern() and
      i = 0
    }

    override string toString() {
      if this.hasSubPattern()
      then result = "." + this.getElement().toString() + "(...)"
      else result = "." + this.getElement().toString()
    }
  }
}
