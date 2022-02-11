/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

// TODO: Change this to always be a list or a constant.
private newtype TGvn =
  TConstantGvn(string s) { s = any(Expr e).getValue() } or
  TVariableGvn(Declaration d) or
  TMethodGvn(Method m) or
  TListExprGvn(GvnList l)

// TODO: Change this to be TGvnKindDeclaration and only allow referenceAttribute like stuff.
private newtype TGvnKind =
  TGvnKindNone() or
  TGvnKindMethod(Method m)

abstract private class GvnKind extends TGvnKind {
  abstract string toString();
}

private class GvnKindNone extends GvnKind, TGvnKindNone {
  GvnKindNone() { this = TGvnKindNone() }

  override string toString() { result = "GvnKindNone" }
}

private class GvnKindMethod extends GvnKind, TGvnKindMethod {
  private Method m;

  GvnKindMethod() { this = TGvnKindMethod(m) }

  override string toString() { result = "GvnKindMethod(" + m.toString() + ")" }
}

/**
 * Type for containing a global value number for expressions with an arbitrary number of children.
 * The empty list carries the kind of the expression.
 */
private newtype TGvnList =
  // TODO: Make a limitation. Eg. only int kind that represents methods, when relevant kind
  // TODO: Consider to make a GvNil for statement and only with an int kind.
  TGvnNil(int kind, GvnKind gkind) { expressions(_, kind, _) } or
  TGvnCons(Gvn head, GvnList tail) { gvnConstructedCons(_, _, _, head, tail) }

// TODO: Do we need no inline pragma?
private GvnList gvnConstructed(Expr e, int kind, int index) {
  (
    if e instanceof MethodCall
    then result = TGvnNil(kind, TGvnKindMethod(e.(MethodCall).getTarget()))
    else result = TGvnNil(kind, any(GvnKindNone gk))
  ) and
  index = -1 and // TODO: Is this correct? Should it be something else depending on the kind of expression?
  expressions(e, kind, _)
  or
  exists(Gvn head, GvnList tail |
    gvnConstructedCons(e, kind, index, head, tail) and
    result = TGvnCons(head, tail)
  )
}

private predicate myTest22(
  Expr e, GvnList l, int kind, int index, int actchildren, int adjustedchildren, int children
) {
  e.fromSource() and
  l = gvnConstructed(e, kind, index) and
  actchildren = getNumberOfActualChildren(e) and
  adjustedchildren = getNumberOfChildren(e) and
  children = e.getNumberOfChildren()
}

private predicate testGetChild(Expr parent, Expr child, int i) {
  child = getChild(parent, i) and parent.fromSource()
}

private predicate testGetChild2(Expr parent, Expr child, int i) {
  child = parent.getChild(i) and parent.fromSource()
}

private predicate myTest3(Expr e, Gvn gvn) {
  e.fromSource() and
  gvn = toGvn(e)
}

// TODO: Use getRankedChild. instead of getChild.
private ControlFlowElement getRankedChild(ControlFlowElement cfe, int rnk) {
  result =
    rank[rnk + 1](ControlFlowElement child, int j | child = cfe.getChild(j) | child order by j)
}

private Expr getChild(Expr e, int child) {
  if e instanceof MethodCall
  then result = e.(MethodCall).getRawArgument(child)
  else result = e.getChild(child)
}

// TODO: Do we need noinline pragma?
private predicate gvnConstructedCons(Expr e, int kind, int index, Gvn head, GvnList tail) {
  tail = gvnConstructed(e, kind, index - 1) and
  head = toGvn(getChild(e, index))
}

abstract private class GvnList extends TGvnList {
  abstract string toString();
}

private class GvnNil extends GvnList, TGvnNil {
  private int kind;
  private GvnKind gkind;

  GvnNil() { this = TGvnNil(kind, gkind) }

  override string toString() { result = "Nil(kind:" + kind + ", gkind:" + gkind + ")]" }
}

private class GvnCons extends GvnList, TGvnCons {
  private Gvn head;
  private GvnList tail;

  GvnCons() { this = TGvnCons(head, tail) }

  override string toString() { result = head.toString() + " :: " + tail.toString() }
}

private Declaration referenceAttribute(Expr e) {
  // result = e.(MethodCall).getTarget()
  // or
  // The cases below should probably also be handled explicitly somehow.
  result = e.(ObjectCreation).getTarget()
  // or
  // result = e.(Access).getTarget()
}

private int getNumberOfActualChildren(ControlFlowElement e) {
  if e.(MemberAccess).targetIsThisInstance()
  then result = e.getNumberOfChildren() - 1
  else result = e.getNumberOfChildren()
}

private int getNumberOfChildren(Expr e) {
  exists(int ref |
    (if exists(referenceAttribute(e)) then ref = 1 else ref = 0) and
    result = getNumberOfActualChildren(e) + ref
  )
}

Gvn toGvn(Expr e) {
  result = TConstantGvn(e.getValue())
  or
  not exists(e.getValue()) and
  (
    result = TVariableGvn(e.(VariableAccess).getTarget())
    or
    // This doesn't correctly capture the argument expressions.
    // result = TMethodGvn(e.(MethodCall).getTarget())
    // or
    exists(GvnList l, int kind, int index |
      l = gvnConstructed(e, kind, index - 1) and
      index = getNumberOfChildren(e) and // TODO: Should this be factored
      result = TListExprGvn(l)
    )
  )
}

abstract class Gvn extends TGvn {
  abstract string toString();
}

private class ConstantGvn extends Gvn, TConstantGvn {
  override string toString() { this = TConstantGvn(result) }
}

private class VariableGvn extends Gvn, TVariableGvn {
  private Declaration d;

  VariableGvn() { this = TVariableGvn(d) }

  override string toString() { result = d.toString() }
}

private class MethodGvn extends Gvn, TMethodGvn {
  private Method m;

  MethodGvn() { this = TMethodGvn(m) }

  override string toString() { result = m.toString() }
}

private class ListExprGvn extends Gvn, TListExprGvn {
  private GvnList l;

  ListExprGvn() { this = TListExprGvn(l) }

  override string toString() { result = "[" + l.toString() + "]" }
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
