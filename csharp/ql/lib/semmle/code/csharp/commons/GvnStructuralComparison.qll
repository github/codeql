/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

// TODO: Everyting should be generalized to ControlFlowElement.
// TODO: Do we need any inlining or caching?
// TODO: Consider to make a GvNil for statement and only with an int kind.
// TODO: Elaborate on descriptions. Maybe provide some examples.
// TODO: Test against the existing usecases.
// TODO: Make tests for the new functionality, such we have a chance of changing the implementation later.
private newtype TGvnKind =
  TGvnKindInt(int kind) { expressions(_, kind, _) } or
  TGvnKindDeclaration(Declaration d) { d = referenceAttribute(_) }

abstract private class GvnKind extends TGvnKind {
  abstract string toString();
}

private class GvnKindInt extends GvnKind, TGvnKindInt {
  private int kind;

  GvnKindInt() { this = TGvnKindInt(kind) }

  override string toString() { result = kind.toString() }
}

private class GvnKindDeclaration extends GvnKind, TGvnKindDeclaration {
  private Declaration d;

  GvnKindDeclaration() { this = TGvnKindDeclaration(d) }

  override string toString() { result = d.toString() }
}

private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

private newtype TGvn =
  TConstantGvn(string s) { s = any(Expr e).getValue() } or
  TListExprGvn(GvnList l)

abstract class Gvn extends TGvn {
  abstract string toString();
}

private class ConstantGvn extends Gvn, TConstantGvn {
  override string toString() { this = TConstantGvn(result) }
}

private class ListExprGvn extends Gvn, TListExprGvn {
  private GvnList l;

  ListExprGvn() { this = TListExprGvn(l) }

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

private GvnKind getGvnKind(Expr e) {
  result = TGvnKindDeclaration(referenceAttribute(e))
  or
  not exists(referenceAttribute(e)) and
  exists(int kind | expressions(e, kind, _) and result = TGvnKindInt(kind))
}

private GvnList gvnConstructed(Expr e, int kind, int index) {
  result = TGvnNil(getGvnKind(e)) and
  index = -1 and
  expressions(e, kind, _) // TODO: Can we re-factor not to get the int kind moved around
  or
  exists(Gvn head, GvnList tail |
    gvnConstructedCons(e, kind, index, head, tail) and
    result = TGvnCons(head, tail)
  )
}

private ControlFlowElement getRankedChild(ControlFlowElement cfe, int rnk) {
  result =
    rank[rnk + 1](ControlFlowElement child, int j | child = cfe.getChild(j) | child order by j)
}

private predicate gvnConstructedCons(Expr e, int kind, int index, Gvn head, GvnList tail) {
  tail = gvnConstructed(e, kind, index - 1) and
  head = toGvn(getRankedChild(e, index))
}

Gvn toGvn(Expr e) {
  result = TConstantGvn(e.getValue())
  or
  not exists(e.getValue()) and
  exists(GvnList l, int kind, int index |
    l = gvnConstructed(e, kind, index - 1) and
    index = e.getNumberOfChildren() and
    result = TListExprGvn(l)
  )
}

abstract class GvnStructuralComparisonConfiguration extends string {
  bindingset[this]
  GvnStructuralComparisonConfiguration() { any() }

  abstract predicate candidate(ControlFlowElement x, ControlFlowElement y);

  private predicate sameInternal(ControlFlowElement x, ControlFlowElement y) { toGvn(x) = toGvn(y) }

  predicate same(ControlFlowElement x, ControlFlowElement y) {
    candidate(x, y) and
    sameInternal(x, y)
  }
}

// Temporary code section
private predicate print(Expr e, Gvn gvn) {
  e.fromSource() and
  gvn = toGvn(e)
}
