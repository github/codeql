/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

private newtype TGvn =
  TConstantGvn(string s) { s = any(Expr e).getValue() } or
  TVariableGvn(Declaration d) or
  TMethodGvn(Method m) or
  //  TBinaryExprGvn(int kind, TGvn child1, TGvn child2) { binaryExpr(_, kind, child1, child2) } or
  TListExprGvn(GvnList l)

private newtype TGvnList =
  TGvnNil(int kind) { expressions(_, kind, _) } or
  TGvnCons(Gvn head, GvnList tail) { gvnConstructedCons(_, _, _, head, tail) }

// TODO: Do we need no inline pragma?
private GvnList gvnConstructed(Expr e, int kind, int index) {
  result = TGvnNil(kind) and
  index = -1 and // TODO: Is this correct? Should it be something else depending on the kind of expression?
  expressions(e, kind, _)
  or
  exists(Gvn head, GvnList tail |
    gvnConstructedCons(e, kind, index, head, tail) and
    result = TGvnCons(head, tail)
  )
}

// TODO: Do we need noinline pragma?
private predicate gvnConstructedCons(Expr e, int kind, int index, Gvn head, GvnList tail) {
  tail = gvnConstructed(e, kind, index - 1) and
  head = toGvn(e.getChild(index))
}

abstract private class GvnList extends TGvnList {
  abstract string toString();
}

private class GvnNil extends GvnList, TGvnNil {
  override string toString() {
    result = "GvnNil" // TODO: Implement this
  }
}

private class GvnCons extends GvnList, TGvnCons {
  override string toString() {
    result = "GvnCons" // TODO: Implement this
  }
}

private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  // The cases below should probably also be handled explicitly somehow.
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

private int getNumberOfChildren(Expr e) {
  exists(int ref |
    (if exists(referenceAttribute(e)) then ref = 1 else ref = 0) and
    result = e.getNumberOfChildren() + ref
  )
}

private predicate myTest(Expr e) { e.fromSource() and getNumberOfChildren(e) = 2 }

// Turns out that a e = M() will have 2 children. One for the method (which is the target) and one for the implicit this access.
private predicate myTest2(Expr e, Declaration d, Expr e1) {
  e.fromSource() and
  getNumberOfChildren(e) = 2 and
  d = referenceAttribute(e) and
  e1 = e.getChild(-1)
}

private predicate binaryExpr(Expr e, int kind, Gvn child1, Gvn child2) {
  getNumberOfChildren(e) = 2 and
  expressions(e, kind, _) and
  child1 = toGvn(e.getChild(0)) and
  child2 = toGvn(e.getChild(1))
}

Gvn toGvn(Expr e) {
  result = TConstantGvn(e.getValue())
  or
  not exists(e.getValue()) and
  (
    result = TVariableGvn(e.(VariableAccess).getTarget())
    or
    // This doesn't correctly capture the argument expressions.
    result = TMethodGvn(e.(MethodCall).getTarget())
    or
    exists(GvnList l, int kind, int index |
      l = gvnConstructed(e, kind, index - 1) and
      index = getNumberOfChildren(e) and // TODO: Should this be factored
      result = TListExprGvn(l)
    )
    // exists(int kind, TGvn child1, TGvn child2 |
    //   binaryExpr(e, kind, child1, child2) and result = TBinaryExprGvn(kind, child1, child2)
    // )
  )
}

private predicate myTest3(Expr e, Gvn gvn) {
  e.fromSource() and
  gvn = toGvn(e)
}

abstract class Gvn extends TGvn {
  abstract string toString();
}

private class ConstantGvn extends Gvn, TConstantGvn {
  override string toString() { this = TConstantGvn(result) }
}

private class VariableGvn extends Gvn, TVariableGvn {
  override string toString() {
    exists(Declaration d |
      this = TVariableGvn(d) and
      result = d.toString()
    )
  }
}

private class MethodGvn extends Gvn, TMethodGvn {
  override string toString() {
    exists(Method m |
      this = TMethodGvn(m) and
      result = m.toString()
    )
  }
}

// private class BinaryExprGvn extends Gvn, TBinaryExprGvn {
//   // Consider better printing, but good enough for now.
//   override string toString() {
//     exists(Gvn child1, Gvn child2, int kind |
//       this = TBinaryExprGvn(kind, child1, child2) and
//       result = child1.toString() + " " + "kind(" + kind + ") " + child2.toString()
//     )
//   }
// }
private class ListExprGvn extends Gvn, TListExprGvn {
  override string toString() {
    exists(GvnList l |
      this = TListExprGvn(l) and
      result = l.toString()
    )
  }
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
