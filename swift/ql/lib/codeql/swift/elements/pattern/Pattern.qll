private import codeql.swift.generated.pattern.Pattern
private import codeql.swift.elements.pattern.EnumElementPattern
private import codeql.swift.elements.pattern.IsPattern
private import codeql.swift.elements.pattern.OptionalSomePattern
private import codeql.swift.elements.pattern.TypedPattern
private import codeql.swift.elements.pattern.TuplePattern
private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.TupleExpr
private import codeql.swift.elements.expr.EnumElementExpr
private import codeql.swift.elements.expr.LookupExpr
private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.stmt.ConditionElement
private import codeql.swift.elements.stmt.SwitchStmt
private import codeql.swift.elements.stmt.CaseStmt
private import codeql.swift.elements.decl.VarDecl
private import codeql.swift.elements.decl.PatternBindingDecl
private import codeql.swift.elements.decl.EnumElementDecl
private import codeql.swift.generated.ParentChild

class Pattern extends Generated::Pattern {
  /**
   * Gets the expression that this pattern is matched against, if any.
   *
   * For example, in `switch e { case p: ... }`, the pattern `p`
   * is matched against the expression `e`.
   */
  Expr getMatchingExpr() {
    exists(ConditionElement c |
      c.getPattern() = this and
      result = c.getInitializer()
    )
    or
    exists(SwitchStmt s |
      s.getExpr() = result and
      s.getACase().getALabel().getPattern() = this
    )
    or
    exists(PatternBindingDecl v, int i |
      v.getPattern(i) = this and
      result = v.getInit(i)
    )
    or
    exists(Pattern p | p.getMatchingExpr() = result |
      this = p.(IsPattern).getSubPattern()
      or
      this = p.(OptionalSomePattern).getSubPattern()
      or
      this = p.(TypedPattern).getSubPattern()
    )
    or
    exists(TuplePattern p, TupleExpr e, int i |
      p.getMatchingExpr() = e and
      this = p.getElement(i) and
      result = e.getElement(i)
    )
    or
    exists(EnumElementPattern p, EnumElementExpr e, int i |
      p.getMatchingExpr() = e and
      this = p.getSubPattern(i) and
      result = e.getArgument(i).getExpr() and
      p.getElement() = e.getElement()
    )
  }

  /** Holds if this pattern is matched against an expression. */
  predicate hasMatchingExpr() { exists(this.getMatchingExpr()) }

  /**
   * Holds if this occurs as a sub-pattern of the result.
   */
  Pattern getEnclosingPattern() {
    this = result.(EnumElementPattern).getImmediateSubPattern()
    or
    this = result.(OptionalSomePattern).getImmediateSubPattern()
    or
    this = result.(TuplePattern).getImmediateElement(_)
    or
    result = this.getIdentityPreservingEnclosingPattern()
  }

  /**
   * Holds if this occurs as a sub-pattern of the result
   * without any intervening destructurings of
   * complex data structures.
   */
  Pattern getIdentityPreservingEnclosingPattern() {
    this = result.(BindingPattern).getImmediateSubPattern()
    or
    this = result.(IsPattern).getImmediateSubPattern()
    or
    this = result.(ParenPattern).getImmediateSubPattern()
    or
    this = result.(TypedPattern).getImmediateSubPattern()
  }
}
