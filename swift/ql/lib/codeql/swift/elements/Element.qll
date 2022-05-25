private import codeql.swift.generated.Element

class Element extends ElementBase {
  private predicate resolvesTo(Element e) { e.getResolveStep() = this }

  override string toString() { result = getPrimaryQlClasses() }

  Element getFullyUnresolved() {
    not this.resolvesTo(_) and result = this
    or
    exists(Element e |
      this.resolvesTo(e) and
      result = e.getFullyUnresolved()
    )
  }
}

class UnknownElement extends Element {
  UnknownElement() { isUnknown() }

  override string toString() { result = "TBD (" + getPrimaryQlClasses() + ")" }
}
