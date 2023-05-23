private import codeql.swift.generated.HideableElement

class HideableElement extends Generated::HideableElement {
  private predicate resolvesFrom(HideableElement e) { e.getResolveStep() = this }

  HideableElement getFullyUnresolved() {
    not this.resolvesFrom(_) and result = this
    or
    exists(HideableElement e |
      this.resolvesFrom(e) and
      result = e.getFullyUnresolved()
    )
  }
}
