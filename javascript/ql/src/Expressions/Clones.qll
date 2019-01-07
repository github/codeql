/**
 * Provides predicates for detecting pairs of identical AST subtrees.
 */

import javascript

/**
 * Gets an opaque integer value encoding the type of AST node `nd`.
 */
private int kindOf(ASTNode nd) {
  // map expression kinds to even non-negative numbers
  result = nd.(Expr).getKind() * 2
  or
  // map statement kinds to odd non-negative numbers
  result = nd.(Stmt).getKind() * 2 + 1
  or
  // other node types get negative kinds
  nd instanceof TopLevel and result = -1
  or
  nd instanceof Property and result = -2
  or
  nd instanceof ClassDefinition and result = -3
}

/**
 * Holds if `nd` has the given `kind`, and its number of children is `arity`.
 */
private predicate kindAndArity(ASTNode nd, int kind, int arity) {
  kindOf(nd) = kind and arity = nd.getNumChild()
}

/**
 * Gets the literal value of AST node `nd`, if any, or the name
 * of `nd` if it is an identifier.
 *
 * Every AST node has at most one value.
 */
private string valueOf(ASTNode nd) {
  result = nd.(Literal).getRawValue() or
  result = nd.(TemplateElement).getRawValue() or
  result = nd.(Identifier).getName()
}

/**
 * A base class for doing structural comparisons of program elements.
 *
 * Clients must override the `candidate()` method to identify the
 * nodes for which structural comparison will be interesting.
 */
abstract class StructurallyCompared extends ASTNode {
  /**
   * Gets a candidate node that we may want to structurally compare this node to.
   */
  abstract ASTNode candidate();

  /**
   * Gets a node that structurally corresponds to this node, either because it is
   * a candidate node, or because it is at the same position relative to a
   * candidate node as this node.
   */
  ASTNode candidateInternal() {
    // in order to correspond, nodes need to have the same kind and shape
    exists(int kind, int numChildren | kindAndArity(this, kind, numChildren) |
      result = candidateKind(kind, numChildren)
      or
      result = uncleKind(kind, numChildren)
    )
  }

  /**
   * Gets a node that structurally corresponds to the parent node of this node,
   * where this node is the `i`th child of its parent.
   */
  private ASTNode getAStructuralUncle(int i) {
    exists(StructurallyCompared parent | this = parent.getChild(i) |
      result = parent.candidateInternal()
    )
  }

  private ASTNode candidateKind(int kind, int numChildren) {
    result = candidate() and kindAndArity(result, kind, numChildren)
  }

  pragma[noinline]
  private ASTNode uncleKind(int kind, int numChildren) {
    exists(int i | result = getAStructuralUncle(i).getChild(i)) and
    kindAndArity(result, kind, numChildren)
  }

  /**
   * Holds if the subtree rooted at this node is structurally equal to the subtree
   * rooted at node `that`, where `that` structurally corresponds to `this` as
   * determined by `candidateInternal`.
   */
  private predicate sameInternal(ASTNode that) {
    that = this.candidateInternal() and
    /*
     * Check that `this` and `that` bind to the same variable, if any.
     * Note that it suffices to check the implication one way: since we restrict
     * `this` and `that` to be of the same kind and in the same syntactic
     * position, either both bind to a variable or neither does.
     */

    (bind(this, _) implies exists(Variable v | bind(this, v) and bind(that, v))) and
    /*
     * Check that `this` and `that` have the same constant value, if any.
     * As above, it suffices to check one implication.
     */

    (exists(valueOf(this)) implies valueOf(this) = valueOf(that)) and
    forall(StructurallyCompared child, int i |
      child = getChild(i) and that = child.getAStructuralUncle(i)
    |
      child.sameInternal(that.getChild(i))
    )
  }

  /**
   * Holds if the subtree rooted at this node is structurally equal to the subtree
   * rooted at node `that`, which must be a candidate node as determined by
   * `candidate`.
   */
  predicate same(ASTNode that) {
    that = this.candidate() and
    this.sameInternal(that)
  }
}

/**
 * A child of a node that is subject to structural comparison.
 */
private class InternalCandidate extends StructurallyCompared {
  InternalCandidate() { exists(getParent().(StructurallyCompared).candidateInternal()) }

  override ASTNode candidate() { none() }
}

/**
 * A clone detector for finding comparisons where both operands are
 * structurally identical.
 */
class OperandComparedToSelf extends StructurallyCompared {
  OperandComparedToSelf() { exists(Comparison comp | this = comp.getLeftOperand()) }

  override Expr candidate() { result = getParent().(Comparison).getRightOperand() }
}

/**
 * A clone detector for finding assignments where both sides are
 * structurally identical.
 */
class SelfAssignment extends StructurallyCompared {
  SelfAssignment() { exists(AssignExpr assgn | this = assgn.getLhs()) }

  override Expr candidate() { result = getAssignment().getRhs() }

  /**
   * Gets the enclosing assignment.
   */
  AssignExpr getAssignment() { result.getLhs() = this }
}

/**
 * A clone detector for finding structurally identical property
 * initializers.
 */
class DuplicatePropertyInitDetector extends StructurallyCompared {
  DuplicatePropertyInitDetector() {
    exists(ObjectExpr oe, string p |
      this = oe.getPropertyByName(p).getInit() and
      oe.getPropertyByName(p) != oe.getPropertyByName(p)
    )
  }

  override Expr candidate() {
    exists(ObjectExpr oe, string p |
      this = oe.getPropertyByName(p).getInit() and
      result = oe.getPropertyByName(p).getInit() and
      result != this
    )
  }
}
