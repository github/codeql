/**
 * INTERNAL: Do not use.
 *
 * Provides logic for calculating the child relation on expressions and statements.
 */

import csharp

/**
 * INTERNAL: Do not use.
 *
 * The `expr_parent_top_level()` relation extended to include a relation
 * between getters and expression bodies in properties such as `int P => 0`.
 */
predicate expr_parent_top_level_adjusted(Expr child, int i, @top_level_exprorstmt_parent parent) {
  expr_parent_top_level(child, i, parent)
  or
  parent = any(Getter g | expr_parent_top_level(child, i, g.getDeclaration())) and
  i = 0
}

/**
 * The `expr_parent()` relation adjusted for expandable assignments. For example,
 * the assignment `x += y` is extracted as
 *
 * ```
 *          +=
 *           |
 *           2
 *           |
 *           =
 *          / \
 *         1   0
 *        /     \
 *       x       +
 *              / \
 *             1   0
 *            /     \
 *           x       y
 * ```
 *
 * in order to be able to retrieve the expanded assignment `x = x + y` as the 2nd
 * child. This predicate changes the diagram above into
 *
 * ```
 *          +=
 *         /  \
 *        1    0
 *       /      \
 *      x        y
 * ```
 */
private predicate expr_parent_adjusted(Expr child, int i, ControlFlowElement parent) {
  if parent instanceof AssignOperation
  then
    parent =
      any(AssignOperation ao |
        exists(AssignExpr ae | ae = ao.getExpandedAssignment() |
          i = 0 and
          exists(Expr right |
            // right = `x + y`
            expr_parent(right, 0, ae)
          |
            expr_parent(child, 1, right)
          )
          or
          i = 1 and
          expr_parent(child, 1, ae)
        )
        or
        not ao.hasExpandedAssignment() and
        expr_parent(child, i, parent)
      )
  else expr_parent(child, i, parent)
}

/**
 * INTERNAL: Do not use.
 *
 * An element that can have a child statement or expression.
 */
class ExprOrStmtParent extends Element, @exprorstmt_parent {
  final override ControlFlowElement getChild(int i) {
    result = this.getChildExpr(i) or
    result = this.getChildStmt(i)
  }

  /** Gets the `i`th child expression of this element (zero-based). */
  final Expr getChildExpr(int i) {
    expr_parent_adjusted(result, i, this) or
    result = getTopLevelChild(this, i)
  }

  /** Gets a child expression of this element, if any. */
  final Expr getAChildExpr() { result = this.getChildExpr(_) }

  /** Gets the `i`th child statement of this element (zero-based). */
  final Stmt getChildStmt(int i) {
    stmt_parent(result, i, this) or
    result = getTopLevelChild(this, i)
  }

  /** Gets a child statement of this element, if any. */
  final Stmt getAChildStmt() { result = this.getChildStmt(_) }
}

/**
 * INTERNAL: Do not use.
 *
 * An element that can have a child top-level expression.
 */
class TopLevelExprParent extends Element, @top_level_expr_parent {
  final override Expr getChild(int i) { result = this.getChildExpr(i) }

  /** Gets the `i`th child expression of this element (zero-based). */
  final Expr getChildExpr(int i) { result = getTopLevelChild(this, i) }

  /** Gets a child expression of this element, if any. */
  final Expr getAChildExpr() { result = this.getChildExpr(_) }
}

/**
 * INTERNAL: Do not use.
 *
 * An element that can have a child statement or expression, and where we have
 * encountered multiple potential implementations at compile-time. For example,
 * if we compile both `A.cs`
 *
 * ```
 * namespaces N {
 *   public class C {
 *     public int M() => 0;
 *   }
 * }
 * ```
 *
 * and later `B.cs`
 *
 * ```
 * namespaces N {
 *   public class C {
 *     public int M() => 1;
 *   }
 * }
 * ```
 *
 * then the method `N.C.M` has two implementations, returning `0` and `1`,
 * respectively.
 *
 * The implementation used at run-time is in this case unknown (indeed, it could
 * be a third implementation not encountered during compilation), so we make a
 * guess for the "most likely" implementation in `getBestChild()`.
 */
class MultiImplementationsParent extends ExprOrStmtParent {
  MultiImplementationsParent() {
    exists(int i |
      strictcount(File f |
        exists(ControlFlowElement implementation, Location l | f = l.getFile() |
          stmt_parent_top_level(implementation, i, this) and
          stmt_location(implementation, l)
          or
          expr_parent_top_level_adjusted(implementation, i, this) and
          expr_location(implementation, l)
        )
        or
        hasAccessorAutoImplementation(this, f) and
        i = 0
      ) > 1
    )
  }

  /**
   * Gets a file that contains an implementation `cfe` for the `i`th child of this
   * element.
   */
  private File getAnImplementation(int i, ControlFlowElement cfe) {
    exists(Location l | result = l.getFile() |
      stmt_parent_top_level(cfe, i, this) and
      stmt_location(cfe, l)
      or
      expr_parent_top_level_adjusted(cfe, i, this) and
      expr_location(cfe, l)
    )
  }

  /**
   * Gets a file that contains an implementation `cfe` for the `i`th child of this
   * element, where `t` is the top-level type containing this element (that is,
   * `t` is not a nested type).
   */
  File getAnImplementationInTopLevelType(int i, ControlFlowElement cfe, ValueOrRefType t) {
    result = this.getAnImplementation(i, cfe) and
    t = getTopLevelDeclaringType(this)
  }

  /**
   * Gets a file that contains an auto-implementation for this element, where
   * `t` is the top-level type containing this element (that is, `t` is not a
   * nested type).
   */
  File getAnAutoImplementationFileInTopLevelType(ValueOrRefType t) {
    hasAccessorAutoImplementation(this, result) and
    t = getTopLevelDeclaringType(this)
  }

  private File getAnImplementationFileInTopLevelType(int i, ValueOrRefType t) {
    result = getAnImplementationInTopLevelType(i, _, t)
    or
    result = this.getAnAutoImplementationFileInTopLevelType(t) and
    i = 0
  }

  /**
   * Gets the file containing the "best" implementation of this element, that is, the
   * file considered most likely to contain the actual run-time implementation.
   *
   * The heuristics we use is to choose the implementation belonging to the top-level type
   * with the most control flow elements (excluding `throw` elements). In the case of a tie,
   * we arbitrarily choose the implementation belonging to the last file (in lexicographic
   * order).
   *
   * By counting elements for the top-level type, we ensure that all definitions belonging
   * to the same top-level type will get implementations belonging to the same file.
   */
  File getBestFile() {
    exists(ValueOrRefType t |
      result =
        max(this.getAnImplementationFileInTopLevelType(_, t) as file
          order by
            getImplementationSize(t, file), file.toString()
        )
    )
  }

  /**
   * Gets the i`th child of this element. Only the "best" child among all the possible
   * run-time implementations is returned, namely the child considered most likely to
   * be the actual run-time implementation.
   */
  ControlFlowElement getBestChild(int i) {
    exists(File f, ValueOrRefType t | f = getBestFile() |
      f = this.getAnImplementationInTopLevelType(i, result, t)
    )
  }
}

/** Gets the top-level type containing declaration `d`. */
private ValueOrRefType getTopLevelDeclaringType(Declaration d) {
  result = getDeclaringType+(d) and
  not result instanceof NestedType
}

/** Gets the declaring type of element `e`. */
private ValueOrRefType getDeclaringType(Declaration d) {
  methods(d, _, result, _, _)
  or
  constructors(d, _, result, _)
  or
  destructors(d, _, result, _)
  or
  operators(d, _, _, result, _, _)
  or
  properties(d, _, result, _, _)
  or
  indexers(d, _, result, _, _)
  or
  nested_types(d, result, _)
  or
  fields(d, _, _, result, _, _)
  or
  exists(DeclarationWithAccessors decl | d = decl.getAnAccessor() | result = getDeclaringType(decl))
  or
  exists(Parameterizable p | params(d, _, _, _, _, p, _) | result = getDeclaringType(p))
}

private ControlFlowElement getAChild(ControlFlowElement cfe) {
  expr_parent_adjusted(result, _, cfe) or
  stmt_parent(result, _, cfe)
}

private int getImplementationSize0(ValueOrRefType t, File f) {
  result =
    strictcount(ControlFlowElement cfe |
      exists(MultiImplementationsParent p, ControlFlowElement child |
        cfe = getAChild*(child) and
        not cfe = getAChild*(any(ThrowElement te))
      |
        f = p.getAnImplementationInTopLevelType(_, child, t)
        or
        // Merge stats for partial implementations belonging to the same folder
        t.isPartial() and
        f = p.getAnImplementationInTopLevelType(_, _, t) and
        exists(File fOther, MultiImplementationsParent pOther |
          f.getParentContainer() = fOther.getParentContainer()
        |
          fOther = pOther.getAnImplementationInTopLevelType(_, child, t)
        )
      )
    )
}

private int getImplementationSize1(ValueOrRefType t, File f) {
  result =
    strictsum(MultiImplementationsParent p, int c |
      // Count each auto-implemented accessor as size 4 (getter) or 5 (setter)
      f = p.getAnAutoImplementationFileInTopLevelType(t) and
      if p instanceof Getter then c = 4 else c = 5
    |
      c
    )
}

private int getImplementationSize(ValueOrRefType t, File f) {
  if exists(getImplementationSize0(t, f))
  then
    if exists(getImplementationSize1(t, f))
    then result = getImplementationSize0(t, f) + getImplementationSize1(t, f)
    else result = getImplementationSize0(t, f)
  else result = getImplementationSize1(t, f)
}

/**
 * Holds if declaration `d` should have a location in file `f`, because it is part of a
 * type with multiple implementations, where the most likely run-time implementation is
 * in `f`.
 */
private predicate mustHaveLocationInFile(Declaration d, File f) {
  exists(MultiImplementationsParent p, ValueOrRefType t |
    t = getTopLevelDeclaringType(p) and
    f = p.getBestFile()
  |
    t = getTopLevelDeclaringType(d) or d = t or d = p
  )
}

private predicate hasNoSourceLocation(Element e) { not e.getALocation() instanceof SourceLocation }

cached
private module Cached {
  cached
  ControlFlowElement getTopLevelChild(ExprOrStmtParent p, int i) {
    result = p.(MultiImplementationsParent).getBestChild(i)
    or
    not p instanceof MultiImplementationsParent and
    (stmt_parent_top_level(result, i, p) or expr_parent_top_level_adjusted(result, i, p))
  }

  cached
  Location bestLocation(Element e) {
    result = e.getALocation().(SourceLocation) and
    (mustHaveLocationInFile(e, _) implies mustHaveLocationInFile(e, result.getFile()))
    or
    hasNoSourceLocation(e) and
    result = min(Location l | l = e.getALocation() | l order by l.getFile().toString())
    or
    not exists(e.getALocation()) and
    result instanceof EmptyLocation
  }

  /**
   * INTERNAL: Do not use.
   *
   * Holds if accessor `a` has an auto-implementation in file `f`.
   */
  cached
  predicate hasAccessorAutoImplementation(Accessor a, File f) {
    exists(SourceLocation sl | sl = a.getALocation() |
      f = sl.getFile() and
      not exists(ControlFlowElement cfe, Location l | sl.getFile() = l.getFile() |
        stmt_parent_top_level(cfe, _, a) and
        stmt_location(cfe, l)
        or
        expr_parent_top_level_adjusted(cfe, 0, a) and
        expr_location(cfe, l)
      )
    )
  }
}

import Cached
