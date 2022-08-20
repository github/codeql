private import codeql.swift.generated.Element

class Element extends ElementBase {
  private predicate resolvesFrom(Element e) { e.getResolveStep() = this }

  override string toString() { result = this.getPrimaryQlClasses() }

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
