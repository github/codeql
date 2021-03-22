private import codeql_ruby.AST
private import codeql.Locations
private import internal.AST
private import internal.TreeSitter
private import internal.Variable

/** A pattern. */
class Pattern extends AstNode {
  Pattern() {
    explicitAssignmentNode(toGenerated(this), _) or
    implicitAssignmentNode(toGenerated(this)) or
    implicitParameterAssignmentNode(toGenerated(this), _)
  }

  /** Gets a variable used in (or introduced by) this pattern. */
  Variable getAVariable() { none() }
}

private class LhsExpr_ =
  TVariableAccess or TTokenConstantAccess or TScopeResolutionConstantAccess or TMethodCall or
      TSimpleParameter;

/**
 * A "left-hand-side" expression. An `LhsExpr` can occur on the left-hand side of
 * operator assignments (`AssignOperation`), in patterns (`Pattern`) on the left-hand side of
 * an assignment (`AssignExpr`) or for loop (`ForExpr`), and as the exception
 * variable of a `rescue` clause (`RescueClause`).
 *
 * An `LhsExpr` can be a simple variable, a constant, a call, or an element reference:
 * ```rb
 * var = 1
 * var += 1
 * E = 1
 * foo.bar = 1
 * foo[0] = 1
 * rescue E => var
 * ```
 */
class LhsExpr extends Pattern, LhsExpr_, Expr {
  override Variable getAVariable() { result = this.(VariableAccess).getVariable() }
}

private class TVariablePattern = TVariableAccess or TSimpleParameter;

/** A simple variable pattern. */
class VariablePattern extends Pattern, LhsExpr, TVariablePattern { }

/**
 * A tuple pattern.
 *
 * This includes both tuple patterns in parameters and assignments. Example patterns:
 * ```rb
 * a, self.b = value
 * (a, b), c[3] = value
 * a, b, *rest, c, d = value
 * ```
 */
class TuplePattern extends Pattern, TTuplePattern {
  override string getAPrimaryQlClass() { result = "TuplePattern" }

  private Generated::AstNode getChild(int i) {
    result = toGenerated(this).(Generated::DestructuredParameter).getChild(i)
    or
    result = toGenerated(this).(Generated::DestructuredLeftAssignment).getChild(i)
    or
    toGenerated(this) =
      any(Generated::LeftAssignmentList lal |
        if
          strictcount(int j | exists(lal.getChild(j))) = 1 and
          lal.getChild(0) instanceof Generated::DestructuredLeftAssignment
        then result = lal.getChild(0).(Generated::DestructuredLeftAssignment).getChild(i)
        else result = lal.getChild(i)
      )
  }

  /** Gets the `i`th pattern in this tuple pattern. */
  final Pattern getElement(int i) {
    exists(Generated::AstNode c | c = this.getChild(i) |
      toGenerated(result) = c.(Generated::RestAssignment).getChild()
      or
      toGenerated(result) = c
    )
  }

  /** Gets a sub pattern in this tuple pattern. */
  final Pattern getAnElement() { result = this.getElement(_) }

  /**
   * Gets the index of the pattern with the `*` marker on it, if it exists.
   * In the example below the index is `2`.
   * ```rb
   * a, b, *rest, c, d = value
   * ```
   */
  final int getRestIndex() {
    result = unique(int i | getChild(i) instanceof Generated::RestAssignment)
  }

  override Variable getAVariable() { result = this.getElement(_).getAVariable() }

  override string toString() { result = "(..., ...)" }

  override AstNode getAChild(string pred) { pred = "getElement" and result = getElement(_) }
}
