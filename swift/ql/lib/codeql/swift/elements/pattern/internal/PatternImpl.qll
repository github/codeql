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

module Impl {
  /**
   * A syntactic construct that can be matched against an expression,
   * occurring in switch cases, conditions, and variable bindings.
   */
  class Pattern extends Generated::Pattern {
    /**
     * Gets the expression that this top-level pattern is matched against, if any.
     *
     * For example, in `switch e { case p: ... }`, the pattern `p`
     * is immediately matched against the expression `e`.
     */
    Expr getImmediateMatchingExpr() {
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
        v.getPattern(i) = pragma[only_bind_out](this) and
        result = v.getInit(i)
      )
    }

    /**
     * Gets the expression that this pattern is matched against, if any.
     * The expression and the pattern need not be top-level children of
     * a pattern-matching construct, but they must match each other syntactically.
     *
     * For example, in `switch .some(e) { case let .some(p): ... }`, the pattern `p`
     * is matched against the expression `e`.
     */
    pragma[nomagic]
    Expr getMatchingExpr() {
      result = this.getImmediateMatchingExpr()
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
    final predicate hasMatchingExpr() { exists(this.getMatchingExpr()) }

    /**
     * Gets the parent pattern of this pattern, if any.
     */
    final Pattern getEnclosingPattern() {
      result = this.getFullyUnresolved().(Pattern).getImmediateEnclosingPattern()
    }

    /**
     * Gets the parent pattern of this pattern, if any.
     */
    Pattern getImmediateEnclosingPattern() {
      this = result.(EnumElementPattern).getImmediateSubPattern()
      or
      this = result.(OptionalSomePattern).getImmediateSubPattern()
      or
      this = result.(TuplePattern).getImmediateElement(_)
      or
      this = result.(BindingPattern).getImmediateSubPattern()
      or
      this = result.(IsPattern).getImmediateSubPattern()
      or
      this = result.(ParenPattern).getImmediateSubPattern()
      or
      this = result.(TypedPattern).getImmediateSubPattern()
    }
  }
}
