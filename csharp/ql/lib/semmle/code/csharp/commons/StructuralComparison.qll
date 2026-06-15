/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

abstract private class GvnKind extends TGvnKind {
  abstract string toString();
}

private class GvnKindExpr extends GvnKind, TGvnKindExpr {
  private int kind;

  GvnKindExpr() { this = TGvnKindExpr(kind) }

  override string toString() { result = "Expr(" + kind + ")" }
}

private class GvnKindStmt extends GvnKind, TGvnKindStmt {
  private int kind;

  GvnKindStmt() { this = TGvnKindStmt(kind) }

  override string toString() { result = "Stmt(" + kind + ")" }
}

private class GvnKindDeclaration extends GvnKind, TGvnKindDeclaration {
  private int kind;
  private boolean isTargetThis;
  private Declaration d;

  GvnKindDeclaration() { this = TGvnKindDeclaration(kind, isTargetThis, d) }

  override string toString() { result = "Expr(" + kind + ")," + isTargetThis + "," + d }
}

/** Gets the declaration referenced by the expression `e`, if any. */
private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

/** Gets a Boolean indicating whether the target of the expression `e` is `this`. */
private boolean isTargetThis(Expr e) {
  result = true and e.(MemberAccess).targetIsThisInstance()
  or
  result = false and not e.(MemberAccess).targetIsThisInstance()
}

/**
 * A global value number (GVN) for a control flow element.
 *
 * GVNs are used to map control flow elements to a representation that
 * omits location information, that is, two elements that are structurally
 * equal will be mapped to the same GVN.
 */
class Gvn extends TGvn {
  /** Gets the string representation of this global value number. */
  string toString() { none() }
}

private class ConstantGvn extends Gvn, TConstantGvn {
  override string toString() { this = TConstantGvn(result) }
}

private class GvnNil extends Gvn, TGvnNil {
  private GvnKind kind;

  GvnNil() { this = TGvnNil(kind) }

  override string toString() { result = "(kind:" + kind + ")" }
}

private class GvnCons extends Gvn, TGvnCons {
  private Gvn head;
  private Gvn tail;

  GvnCons() { this = TGvnCons(head, tail) }

  override string toString() { result = "(" + head + " :: " + tail + ")" }
}

pragma[noinline]
private predicate gvnKindDeclaration(Expr e, int kind, boolean isTargetThis, Declaration d) {
  isTargetThis = isTargetThis(e) and
  // guard against elements with multiple declaration targets (DB inconsistency),
  // which may result in a combinatorial explosion
  d = unique(Declaration d0 | d0 = referenceAttribute(e) | d0) and
  expressions(e, kind, _)
}

/**
 * Gets the `GvnKind` of the element `cfe`.
 *
 * In case `cfe` is a reference attribute, we encode the entire declaration and whether
 * the target is semantically equivalent to `this`.
 */
private GvnKind getGvnKind(ControlFlowElement cfe) {
  exists(int kind, boolean isTargetThis, Declaration d |
    gvnKindDeclaration(cfe, kind, isTargetThis, d) and
    result = TGvnKindDeclaration(kind, isTargetThis, d)
  )
  or
  exists(int kind |
    not exists(referenceAttribute(cfe)) and
    expressions(cfe, kind, _) and
    result = TGvnKindExpr(kind)
    or
    statements(cfe, kind) and
    result = TGvnKindStmt(kind)
  )
}

private Gvn toGvn(ControlFlowElement cfe, GvnKind kind, int index) {
  kind = getGvnKind(cfe) and
  result = TGvnNil(kind) and
  index = -1
  or
  exists(Gvn head, Gvn tail |
    toGvnCons(cfe, kind, index, head, tail) and
    result = TGvnCons(head, tail)
  )
}

private int getNumberOfActualChildren(ControlFlowElement cfe) {
  if cfe.(MemberAccess).targetIsThisInstance()
  then result = cfe.getNumberOfChildren() - 1
  else result = cfe.getNumberOfChildren()
}

private ControlFlowElement getRankedChild(ControlFlowElement cfe, int rnk) {
  result =
    rank[rnk + 1](ControlFlowElement child, int j |
      child = cfe.getChild(j) and
      (
        j >= 0
        or
        j = -1 and not cfe.(MemberAccess).targetIsThisInstance()
      )
    |
      child order by j
    )
}

pragma[noinline]
private Gvn toGvnChild(ControlFlowElement cfe, int index) {
  result = toGvn(getRankedChild(cfe, index))
}

pragma[noinline]
private predicate toGvnCons(ControlFlowElement cfe, GvnKind kind, int index, Gvn head, Gvn tail) {
  tail = toGvn(cfe, kind, index - 1) and
  head = toGvnChild(cfe, index)
}

cached
private module Cached {
  cached
  newtype TGvnKind =
    TGvnKindExpr(int kind) { expressions(_, kind, _) } or
    TGvnKindStmt(int kind) { statements(_, kind) } or
    TGvnKindDeclaration(int kind, boolean thisTarget, Declaration d) {
      exists(Expr e |
        d = referenceAttribute(e) and thisTarget = isTargetThis(e) and expressions(e, kind, _)
      )
    }

  cached
  newtype TGvn =
    TConstantGvn(string s) { s = any(Expr e).getValue() } or
    TGvnNil(GvnKind gkind) or
    TGvnCons(Gvn head, Gvn tail) { toGvnCons(_, _, _, head, tail) }

  /** Gets the global value number of the element `cfe`. */
  cached
  Gvn toGvnCached(ControlFlowElement cfe) {
    result = TConstantGvn(cfe.(Expr).getValue())
    or
    not exists(cfe.(Expr).getValue()) and
    exists(int index |
      result = toGvn(cfe, _, index - 1) and
      index = getNumberOfActualChildren(cfe)
    )
  }
}

private import Cached

predicate toGvn = toGvnCached/1;

/**
 * Holds if the control flow elements `x` and `y` are structurally equal.
 */
bindingset[x, y]
pragma[inline_late]
predicate sameGvn(ControlFlowElement x, ControlFlowElement y) { toGvn(x) = toGvn(y) }
