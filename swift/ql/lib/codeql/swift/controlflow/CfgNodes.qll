/** Provides classes representing nodes in a control flow graph. */

private import swift
private import BasicBlocks
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl
private import internal.ControlFlowElements
private import internal.Splitting

/** An entry node for a given scope. */
class EntryNode extends ControlFlowNode, TEntryNode {
  private CfgScope scope;

  EntryNode() { this = TEntryNode(scope) }

  final override EntryBasicBlock getBasicBlock() { result = ControlFlowNode.super.getBasicBlock() }

  final override Location getLocation() { result = scope.getLocation() }

  final override string toString() { result = "enter " + scope }
}

/** An exit node for a given scope, annotated with the type of exit. */
class AnnotatedExitNode extends ControlFlowNode, TAnnotatedExitNode {
  private CfgScope scope;
  private boolean normal;

  AnnotatedExitNode() { this = TAnnotatedExitNode(scope, normal) }

  /** Holds if this node represent a normal exit. */
  final predicate isNormal() { normal = true }

  final override AnnotatedExitBasicBlock getBasicBlock() {
    result = ControlFlowNode.super.getBasicBlock()
  }

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
class ExitNode extends ControlFlowNode, TExitNode {
  private CfgScope scope;

  ExitNode() { this = TExitNode(scope) }

  final override Location getLocation() { result = scope.getLocation() }

  final override string toString() { result = "exit " + scope }
}

/**
 * A node for an AST node.
 *
 * Each AST node maps to zero or more `AstCfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class AstCfgNode extends ControlFlowNode, TElementNode {
  private Splits splits;
  private ControlFlowElement n;

  AstCfgNode() { this = TElementNode(_, n, splits) }

  final override ControlFlowElement getNode() { result = n }

  override Location getLocation() { result = n.getLocation() }

  final override string toString() {
    exists(string s | s = n.toString() |
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

  ExprCfgNode() { e = this.getNode().asAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

class ApplyExprCfgNode extends ExprCfgNode {
  override ApplyExpr e;

  ExprCfgNode getArgument(int index) {
    result.getNode().asAstNode() = e.getArgument(index).getExpr()
  }

  AbstractFunctionDecl getStaticTarget() { result = e.getStaticTarget() }
}

class CallExprCfgNode extends ApplyExprCfgNode {
  override CallExpr e;
}
