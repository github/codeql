/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */

import csharp

private newtype TGvn =
  TConstantGvn(string s) { s = any(Expr e).getValue() } or
  TVariableGvn(Declaration d) or
  TBinaryExprGvn(int kind, TGvn child1, TGvn child2) { binaryExpr(_, kind, child1, child2) }

private int getNumberOfChildren(Expr r) { result = r.getNumberOfChildren() }

private predicate binaryExpr(Expr e, int kind, TGvn child1, TGvn child2) {
  getNumberOfChildren(e) = 2 and
  expressions(e, kind, _) and
  child1 = toGvn(e.getChild(0)) and
  child2 = toGvn(e.getChild(1))
}

private Gvn toGvn(Expr e) {
  result = TConstantGvn(e.getValue())
  or
  not exists(e.getValue()) and
  (
    result = TVariableGvn(e.(VariableAccess).getTarget())
    or
    exists(int kind, TGvn child1, TGvn child2 |
      binaryExpr(e, kind, child1, child2) and result = TBinaryExprGvn(kind, child1, child2)
    )
  )
}

abstract private class Gvn extends TGvn {
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

private class BinaryExprGvn extends Gvn, TBinaryExprGvn {
  // Consider better printing, but good enough for now.
  override string toString() {
    exists(Gvn child1, Gvn child2, int kind |
      this = TBinaryExprGvn(kind, child1, child2) and
      result = child1.toString() + " " + "kind(" + kind + ") " + child2.toString()
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
