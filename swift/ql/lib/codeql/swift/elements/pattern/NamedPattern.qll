private import codeql.swift.generated.pattern.NamedPattern
private import codeql.swift.elements.decl.VarDecl

class NamedPattern extends Generated::NamedPattern {
  /** Holds if this named pattern has a corresponding `VarDecl` */
  predicate hasVarDecl() { exists(this.getVarDecl()) }

  /** Gets the `VarDecl` bound by this named pattern, if any. */
  VarDecl getVarDecl() {
    this.getEnclosingPattern*() = result.getParentPattern().getFullyUnresolved() and
    result.getName() = this.getName()
  }

  override string toString() { result = this.getName() }
}
