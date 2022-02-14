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
// TODO: Cleanup temporary code section.
// TODO: Rename ListExpGvn as it covers more than expressions.
// TODO: Consider using different constructors for statements and expressions.
private newtype TGvnKind =
  TGvnKindInt(int kind) { kind = getKind(_) } or
  TGvnKindDeclaration(int kind, Declaration d) {
    exists(Expr e | d = referenceAttribute(e) and expressions(e, kind, _))
  }

abstract private class GvnKind extends TGvnKind {
  abstract string toString();
}

private class GvnKindInt extends GvnKind, TGvnKindInt {
  private int kind;

  GvnKindInt() { this = TGvnKindInt(kind) }

  override string toString() { result = kind.toString() }
}

private class GvnKindDeclaration extends GvnKind, TGvnKindDeclaration {
  private int kind;
  private Declaration d;

  GvnKindDeclaration() { this = TGvnKindDeclaration(kind, d) }

  override string toString() { result = kind.toString() + "," + d.toString() }
}

private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

private int getKind(ControlFlowElement cfe) {
  expressions(cfe, result, _)
  or
  exists(int kind | statements(cfe, kind) and result = -kind)
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

private GvnKind getGvnKind(ControlFlowElement cfe) {
  exists(int kind |
    kind = getKind(cfe) and
    (
      result = TGvnKindDeclaration(kind, referenceAttribute(cfe))
      or
      not exists(referenceAttribute(cfe)) and
      result = TGvnKindInt(kind)
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

private ControlFlowElement getRankedChild(ControlFlowElement cfe, int rnk) {
  result =
    rank[rnk + 1](ControlFlowElement child, int j | child = cfe.getChild(j) | child order by j)
}

private predicate gvnConstructedCons(
  ControlFlowElement e, GvnKind kind, int index, Gvn head, GvnList tail
) {
  tail = gvnConstructed(e, kind, index - 1) and
  head = toGvn(getRankedChild(e, index))
}

Gvn toGvn(ControlFlowElement e) {
  result = TConstantGvn(e.(Expr).getValue())
  or
  not exists(e.(Expr).getValue()) and
  exists(GvnList l, GvnKind kind, int index |
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
private predicate print(ControlFlowElement e, Gvn gvn) {
  e.fromSource() and
  gvn = toGvn(e)
}
