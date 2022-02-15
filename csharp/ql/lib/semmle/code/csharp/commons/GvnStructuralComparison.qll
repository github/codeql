/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

// TODO: Elaborate on descriptions. Maybe provide some examples.
// TODO: Make tests for the new functionality, such we have a chance of changing the implementation later.
private newtype TGvnKind =
  TGvnKindExpr(int kind) { expressions(_, kind, _) } or
  TGvnKindStmt(int kind) { statements(_, kind) } or
  TGvnKindDeclaration(GvnKindExpr kind, boolean thisTarget, Declaration d) {
    exists(Expr e |
      d = referenceAttribute(e) and thisTarget = isTargetThis(e) and kind = getKind(e)
    )
  }

abstract private class GvnKind extends TGvnKind {
  abstract string toString();
}

private class GvnKindExpr extends GvnKind, TGvnKindExpr {
  private int kind;

  GvnKindExpr() { this = TGvnKindExpr(kind) }

  override string toString() { result = "Expr(" + kind.toString() + ")" }
}

private class GvnKindStmt extends GvnKind, TGvnKindStmt {
  private int kind;

  GvnKindStmt() { this = TGvnKindStmt(kind) }

  override string toString() { result = "Stmt(" + kind.toString() + ")" }
}

private class GvnKindDeclaration extends GvnKind, TGvnKindDeclaration {
  private GvnKindExpr kind;
  private boolean isTargetThis;
  private Declaration d;

  GvnKindDeclaration() { this = TGvnKindDeclaration(kind, isTargetThis, d) }

  override string toString() { result = kind.toString() + "," + isTargetThis + "," + d.toString() }
}

private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

private boolean isTargetThis(Expr cfe) {
  result = true and cfe.(MemberAccess).targetIsThisInstance()
  or
  result = false and not cfe.(MemberAccess).targetIsThisInstance()
}

private GvnKind getKind(ControlFlowElement cfe) {
  exists(int kind |
    expressions(cfe, kind, _) and
    result = TGvnKindExpr(kind)
    or
    statements(cfe, kind) and
    result = TGvnKindStmt(kind)
  )
}

private newtype TGvn =
  TConstantGvn(string s) { s = any(Expr e).getValue() } or
  TListGvn(GvnList l)

abstract class Gvn extends TGvn {
  abstract string toString();
}

private class ConstantGvn extends Gvn, TConstantGvn {
  override string toString() { this = TConstantGvn(result) }
}

private class ListGvn extends Gvn, TListGvn {
  private GvnList l;

  ListGvn() { this = TListGvn(l) }

  override string toString() { result = "[" + l.toString() + "]" }
}

/**
 * Type for containing a list of global value numbers with a kind.
 * The empty list carries the kind of the controlflowelement.
 */
private newtype TGvnList =
  TGvnNil(GvnKind gkind) or
  TGvnCons(Gvn head, GvnList tail) { gvnConstructedCons(_, _, _, head, tail) }

abstract private class GvnList extends TGvnList {
  abstract string toString();
}

private class GvnNil extends GvnList, TGvnNil {
  private GvnKind kind;

  GvnNil() { this = TGvnNil(kind) }

  override string toString() { result = "(kind:" + kind + ")" }
}

private class GvnCons extends GvnList, TGvnCons {
  private Gvn head;
  private GvnList tail;

  GvnCons() { this = TGvnCons(head, tail) }

  override string toString() { result = head.toString() + " :: " + tail.toString() }
}

private GvnKind getGvnKind(ControlFlowElement cfe) {
  exists(GvnKind kind |
    kind = getKind(cfe) and
    (
      result = TGvnKindDeclaration(kind, isTargetThis(cfe), referenceAttribute(cfe))
      or
      not exists(referenceAttribute(cfe)) and
      result = kind
    )
  )
}

private GvnList gvnConstructed(ControlFlowElement cfe, GvnKind kind, int index) {
  kind = getGvnKind(cfe) and
  result = TGvnNil(kind) and
  index = -1
  or
  exists(Gvn head, GvnList tail |
    gvnConstructedCons(cfe, kind, index, head, tail) and
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

private predicate gvnConstructedCons(
  ControlFlowElement e, GvnKind kind, int index, Gvn head, GvnList tail
) {
  tail = gvnConstructed(e, kind, index - 1) and
  head = toGvn(getRankedChild(e, index))
}

Gvn toGvn(ControlFlowElement cfe) {
  result = TConstantGvn(cfe.(Expr).getValue())
  or
  not exists(cfe.(Expr).getValue()) and
  exists(GvnList l, GvnKind kind, int index |
    l = gvnConstructed(cfe, kind, index - 1) and
    index = getNumberOfActualChildren(cfe) and
    result = TListGvn(l)
  )
}

abstract class StructuralComparisonConfiguration extends string {
  bindingset[this]
  StructuralComparisonConfiguration() { any() }

  abstract predicate candidate(ControlFlowElement x, ControlFlowElement y);

  predicate same(ControlFlowElement x, ControlFlowElement y) {
    candidate(x, y) and
    toGvn(x) = toGvn(y)
  }
}

module Internal {
  private import semmle.code.csharp.controlflow.Guards as G

  abstract class InternalStructuralComparisonConfiguration extends string {
    bindingset[this]
    InternalStructuralComparisonConfiguration() { any() }

    abstract predicate candidate(ControlFlowElement x, ControlFlowElement y);

    predicate same(ControlFlowElement x, ControlFlowElement y) {
      candidate(x, y) and
      toGvn(x) = toGvn(y)
    }
  }
}
