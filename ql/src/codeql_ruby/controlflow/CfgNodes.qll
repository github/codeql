/** Provides classes representing nodes in a control flow graph. */

private import codeql_ruby.AST
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.controlflow.BasicBlocks
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl
private import internal.Splitting

/** An entry node for a given scope. */
class EntryNode extends CfgNode, TEntryNode {
  private CfgScope scope;

  EntryNode() { this = TEntryNode(scope) }

  final override EntryBasicBlock getBasicBlock() { result = CfgNode.super.getBasicBlock() }

  final override Location getLocation() { result = scope.getLocation() }

  final override string toString() { result = "enter " + scope }
}

/** An exit node for a given scope, annotated with the type of exit. */
class AnnotatedExitNode extends CfgNode, TAnnotatedExitNode {
  private CfgScope scope;
  private boolean normal;

  AnnotatedExitNode() { this = TAnnotatedExitNode(scope, normal) }

  /** Holds if this node represent a normal exit. */
  final predicate isNormal() { normal = true }

  final override AnnotatedExitBasicBlock getBasicBlock() { result = CfgNode.super.getBasicBlock() }

  final override Location getLocation() { result = scope.getLocation() }

  final override string toString() {
    exists(string s |
      normal = true and s = "normal"
      or
      normal = false and s = "abnormal"
    |
      result = "exit " + scope + " (" + s + ")"
    )
  }
}

/** An exit node for a given scope. */
class ExitNode extends CfgNode, TExitNode {
  private CfgScope scope;

  ExitNode() { this = TExitNode(scope) }

  final override Location getLocation() { result = scope.getLocation() }

  final override string toString() { result = "exit " + scope }
}

/**
 * A node for an AST node.
 *
 * Each AST node maps to zero or more `AstCfgNode`s: zero when the node in unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class AstCfgNode extends CfgNode, TAstNode {
  private Splits splits;
  private Generated::AstNode n;

  AstCfgNode() { this = TAstNode(n, splits) }

  final override AstNode getNode() { result = n }

  final override string toString() {
    exists(string s |
      // TODO: Remove once the SSA implementation is based on the AST layer
      s = n.(AstNode).toString() and
      s != "AstNode"
      or
      n.(AstNode).toString() = "AstNode" and
      s = n.toString()
    |
      result = "[" + this.getSplitsString() + "] " + s
      or
      not exists(this.getSplitsString()) and result = s
    )
  }

  /** Gets a comma-separated list of strings for each split in this node, if any. */
  final string getSplitsString() {
    result = splits.toString() and
    result != ""
  }

  /** Gets a split for this control flow node, if any. */
  final Split getASplit() { result = splits.getASplit() }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends AstCfgNode {
  Expr e;

  ExprCfgNode() { e = this.getNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ExprChildMapping extends Expr {
  /**
   * Holds if `child` is a (possibly nested) child of this expression
   * for which we would like to find a matching CFG child.
   */
  abstract predicate relevantChild(Expr child);

  private AstNode getAChildStar() {
    result = this
    or
    result.(Generated::AstNode).getParent() = this.getAChildStar()
  }

  pragma[noinline]
  private BasicBlock getABasicBlockInScope() { result.getANode().getNode() = this.getAChildStar() }

  pragma[nomagic]
  private predicate reachesBasicBlockBase(Expr child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn = this.getAControlFlowNode() and
    bb.getANode() = cfn
  }

  pragma[nomagic]
  private predicate reachesBasicBlock(Expr child, CfgNode cfn, BasicBlock bb) {
    this.reachesBasicBlockBase(child, cfn, bb)
    or
    this.relevantChild(child) and
    this.reachesBasicBlockRec(child, cfn, bb) and
    bb = this.getABasicBlockInScope()
  }

  pragma[nomagic]
  private predicate reachesBasicBlockRec(Expr child, CfgNode cfn, BasicBlock bb) {
    exists(BasicBlock mid | this.reachesBasicBlock(child, cfn, mid) |
      bb = mid.getASuccessor()
      or
      bb = mid.getAPredecessor()
    )
  }

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnChild`, where `cfn`
   * is a control-flow node for this expression, and `cfnChild` is a control-flow
   * node for `child`.
   *
   * The path never escapes the syntactic scope of this expression.
   */
  cached
  predicate hasCfgChild(Expr child, CfgNode cfn, CfgNode cfnChild) {
    exists(BasicBlock bb |
      this.reachesBasicBlockBase(child, cfn, bb) and
      cfnChild = bb.getANode() and
      cfnChild = child.getAControlFlowNode()
    )
    or
    exists(BasicBlock bb |
      this.reachesBasicBlockRec(child, cfn, bb) and
      cfnChild = bb.getANode() and
      cfnChild = child.getAControlFlowNode()
    )
  }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  // TODO: Add more classes
  private class BinaryOperationExprChildMapping extends ExprChildMapping, BinaryOperation {
    override predicate relevantChild(Expr e) { e = this.getAnOperand() }
  }

  /** A control-flow node that wraps a `BinaryOperation` AST expression. */
  class BinaryOperationCfgNode extends ExprCfgNode {
    override BinaryOperationExprChildMapping e;

    final override BinaryOperation getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the left operand of this binary operation. */
    final ExprCfgNode getLeftOperand() { e.hasCfgChild(e.getLeftOperand(), this, result) }

    /** Gets the right operand of this binary operation. */
    final ExprCfgNode getRightOperand() { e.hasCfgChild(e.getRightOperand(), this, result) }
  }

  /** A control-flow node that wraps a `VariableReadAccess` AST expression. */
  class VariableReadAccessCfgNode extends ExprCfgNode {
    override VariableReadAccess e;

    final override VariableReadAccess getExpr() { result = ExprCfgNode.super.getExpr() }
  }
}
