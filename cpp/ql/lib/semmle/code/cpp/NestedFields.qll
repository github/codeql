/**
 * Provides a class for reasoning about nested field accesses, for example
 * the access `myLine.start.x`.
 */

import cpp

/**
 * Gets a `Field` that is within the given `Struct`, either directly or nested
 * inside one or more levels of member structs.
 */
private Field getANestedField(Struct s) {
  result = s.getAField()
  or
  exists(NestedStruct ns |
    s = ns.getDeclaringType() and
    result = getANestedField(ns)
  )
}

/**
 * Unwraps a series of field accesses to determine the outer-most qualifier.
 */
private Expr getUltimateQualifier(FieldAccess fa) {
  exists(Expr qualifier | qualifier = fa.getQualifier() |
    result = getUltimateQualifier(qualifier)
    or
    not qualifier instanceof FieldAccess and result = qualifier
  )
}

/**
 * A nested field access, for example the access `myLine.start.x`.
 */
class NestedFieldAccess extends FieldAccess {
  Expr ultimateQualifier;

  NestedFieldAccess() {
    ultimateQualifier = getUltimateQualifier(this) and
    this.getTarget() = getANestedField(ultimateQualifier.getType().stripType())
  }

  /**
   * Gets the outermost qualifier of this nested field access. In the
   * following example, the access to `myLine.start.x` has outermost qualifier
   * `myLine`:
   * ```
   * struct Point
   * {
   *   float x, y;
   * };
   *
   * struct Line
   * {
   *   Point start, end;
   * };
   *
   * void init()
   * {
   *   Line myLine;
   *
   *   myLine.start.x = 0.0f;
   *
   *   // ...
   * }
   * ```
   */
  Expr getUltimateQualifier() { result = ultimateQualifier }
}
