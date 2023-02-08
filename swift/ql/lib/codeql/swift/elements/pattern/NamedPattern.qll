private import codeql.swift.generated.pattern.NamedPattern
private import codeql.swift.elements.pattern.BindingPattern
private import codeql.swift.elements.pattern.EnumElementPattern
private import codeql.swift.elements.pattern.IsPattern
private import codeql.swift.elements.pattern.OptionalSomePattern
private import codeql.swift.elements.pattern.ParenPattern
private import codeql.swift.elements.pattern.TuplePattern
private import codeql.swift.elements.pattern.TypedPattern
private import codeql.swift.elements.decl.VarDecl
private import codeql.swift.elements.stmt.LabeledConditionalStmt
private import codeql.swift.elements.stmt.ConditionElement

class NamedPattern extends Generated::NamedPattern {
  /** Holds if this named pattern has a corresponding `VarDecl` */
  predicate hasVarDecl() { exists(this.getVarDecl()) }

  /** Gets the `VarDecl` bound by this named pattern, if any. */
  VarDecl getVarDecl() {
    isSubPattern*(result.getParentPattern().getFullyUnresolved(), this) and
    result.getName() = this.getName()
  }

  override string toString() { result = this.getName() }
}

private predicate isSubPattern(Pattern p, Pattern sub) {
  sub = p.(BindingPattern).getImmediateSubPattern()
  or
  sub = p.(EnumElementPattern).getImmediateSubPattern()
  or
  sub = p.(IsPattern).getImmediateSubPattern()
  or
  sub = p.(OptionalSomePattern).getImmediateSubPattern()
  or
  sub = p.(ParenPattern).getImmediateSubPattern()
  or
  sub = p.(TuplePattern).getImmediateElement(_)
  or
  sub = p.(TypedPattern).getImmediateSubPattern()
}
