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
 * Each AST node maps to zero or more `CfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class CfgNode extends ControlFlowNode, TElementNode {
  private Splits splits;
  ControlFlowElement n;

  CfgNode() { this = TElementNode(_, n, splits) }

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

  /** Gets the AST representation of this control flow node, if any. */
  Expr getAst() {
    result = n.asAstNode()
    or
    result = n.(PropertyGetterElement).getRef()
    or
    result = n.(PropertySetterElement).getAssignExpr()
    or
    result = n.(PropertyObserverElement).getAssignExpr()
    or
    result = n.(ClosureElement).getAst()
    or
    result = n.(KeyPathElement).getAst()
  }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends CfgNode {
  Expr e;

  ExprCfgNode() { e = this.getNode().asAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

/** A control-flow node that wraps a property getter. */
class PropertyGetterCfgNode extends CfgNode {
  override PropertyGetterElement n;

  Expr getRef() { result = n.getRef() }

  CfgNode getBase() { result.getAst() = n.getBase() }

  AccessorDecl getAccessorDecl() { result = n.getAccessorDecl() }
}

/** A control-flow node that wraps a property setter. */
class PropertySetterCfgNode extends CfgNode {
  override PropertySetterElement n;

  AssignExpr getAssignExpr() { result = n.getAssignExpr() }

  CfgNode getBase() { result.getAst() = n.getBase() }

  CfgNode getSource() { result.getAst() = n.getAssignExpr().getSource() }

  AccessorDecl getAccessorDecl() { result = n.getAccessorDecl() }
}

class PropertyObserverCfgNode extends CfgNode {
  override PropertyObserverElement n;

  AssignExpr getAssignExpr() { result = n.getAssignExpr() }

  CfgNode getBase() { result.getAst() = n.getBase() }

  CfgNode getSource() { result.getAst() = n.getAssignExpr().getSource() }

  AccessorDecl getAccessorDecl() { result = n.getObserver() }
}

class ApplyExprCfgNode extends ExprCfgNode {
  override ApplyExpr e;

  CfgNode getArgument(int index) { result.getAst() = e.getArgument(index).getExpr() }

  CfgNode getQualifier() { result.getAst() = e.getQualifier() }

  AbstractFunctionDecl getStaticTarget() { result = e.getStaticTarget() }

  Expr getFunction() { result = e.getFunction() }
}

class CallExprCfgNode extends ApplyExprCfgNode {
  override CallExpr e;
}
