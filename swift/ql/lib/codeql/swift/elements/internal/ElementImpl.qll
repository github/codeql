private import codeql.swift.generated.Element

module Impl {
  class Element extends Generated::Element {
    private predicate resolvesFrom(Element e) { e.getResolveStep() = this }

    override string toStringImpl() { result = this.getPrimaryQlClasses() }

    Element getFullyUnresolved() {
      not this.resolvesFrom(_) and result = this
      or
      exists(Element e |
        this.resolvesFrom(e) and
        result = e.getFullyUnresolved()
      )
    }
  }

  class UnknownElement extends Element {
    UnknownElement() { this.isUnknown() }
  }
}
