import ql

signature predicate checkAstNodeSig(AstNode p);

module ConjunctionParent<checkAstNodeSig/1 checkAstNode> {
  /**
   * Gets the top-most parent of `p` that is not a disjunction.
   */
  AstNode getConjunctionParent(AstNode p) {
    result =
      min(int level, AstNode parent |
        parent = getConjunctionParentRec(p) and level = level(parent)
      |
        parent order by level
      )
  }

  /**
   * Gets a (transitive) parent of `p`, where the parent is not a negative edge, and `checkAstNode(p)` holds.
   */
  private AstNode getConjunctionParentRec(AstNode p) {
    checkAstNode(p) and
    result = p
    or
    result = getConjunctionParentRec(p).getParent() and
    not result instanceof Disjunction and
    not result instanceof IfFormula and
    not result instanceof Implication and
    not result instanceof Negation and
    not result instanceof Predicate and
    not result instanceof ExprAggregate and
    not result instanceof FullAggregate and
    not result instanceof Forex and
    not result instanceof Forall
  }

  /**
   * Gets which level in the AST `p` is at.
   * E.g. the top-level is 0, the next level is 1, etc.
   */
  private int level(AstNode p) {
    p instanceof TopLevel and result = 0
    or
    result = level(p.getParent()) + 1
  }
}
