private import codeql.swift.generated.pattern.TuplePattern

module Impl {
  class TuplePattern extends Generated::TuplePattern {
    Pattern getFirstElement() { result = this.getElement(0) }

    Pattern getLastElement() {
      exists(int i |
        result = this.getElement(i) and
        not exists(this.getElement(i + 1))
      )
    }

    override string toString() { result = "(...)" }
  }
}
