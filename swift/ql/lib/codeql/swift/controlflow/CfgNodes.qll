/** Provides classes representing nodes in a control flow graph. */

private import swift
private import BasicBlocks
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl as Impl
private import internal.ControlFlowElements
private import internal.Splitting

/**
 * A node for an AST node.
 *
 * Each AST node maps to zero or more `CfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class CfgNode extends ControlFlowNode instanceof Impl::AstCfgNode {
  final override ControlFlowElement getNode() { result = this.getAstNode() }

  /** Gets a split for this control flow node, if any. */
  final Split getASplit() { result = super.getASplit() }

  /** Gets a comma-separated list of strings for each split in this node, if any. */
  final string getSplitsString() { result = super.getSplitsString() }

  /** Gets the AST representation of this control flow node, if any. */
  Expr getAst() {
    result = this.getNode().asAstNode()
    or
    result = this.getNode().(PropertyGetterElement).getRef()
    or
    result = this.getNode().(PropertySetterElement).getAssignExpr()
    or
    result = this.getNode().(PropertyObserverElement).getAssignExpr()
    or
    result = this.getNode().(ClosureElement).getAst()
    or
    result = this.getNode().(KeyPathElement).getAst()
  }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends CfgNode {
  Expr e;

  ExprCfgNode() { e = this.getNode().asAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

/** A control-flow node that wraps a pattern. */
class PatternCfgNode extends CfgNode {
  Pattern p;

  PatternCfgNode() { p = this.getNode().asAstNode() }

  /** Gets the underlying pattern. */
  Pattern getPattern() { result = p }
}

/** A control-flow node that wraps a property getter. */
class PropertyGetterCfgNode extends CfgNode {
  PropertyGetterElement n;

  PropertyGetterCfgNode() { n = this.getAstNode() }

  Expr getRef() { result = n.getRef() }

  CfgNode getBase() { result.getAst() = n.getBase() }

  Accessor getAccessor() { result = n.getAccessor() }
}

/** A control-flow node that wraps a property setter. */
class PropertySetterCfgNode extends CfgNode {
  PropertySetterElement n;

  PropertySetterCfgNode() { n = this.getAstNode() }

  AssignExpr getAssignExpr() { result = n.getAssignExpr() }

  CfgNode getBase() { result.getAst() = n.getBase() }

  CfgNode getSource() { result.getAst() = n.getAssignExpr().getSource() }

  Accessor getAccessor() { result = n.getAccessor() }
}

class PropertyObserverCfgNode extends CfgNode {
  PropertyObserverElement n;

  PropertyObserverCfgNode() { n = this.getAstNode() }

  AssignExpr getAssignExpr() { result = n.getAssignExpr() }

  CfgNode getBase() { result.getAst() = n.getBase() }

  CfgNode getSource() { result.getAst() = n.getAssignExpr().getSource() }

  Accessor getAccessor() { result = n.getObserver() }
}

class ApplyExprCfgNode extends ExprCfgNode {
  override ApplyExpr e;

  CfgNode getArgument(int index) { result.getAst() = e.getArgument(index).getExpr() }

  CfgNode getQualifier() { result.getAst() = e.getQualifier() }

  Callable getStaticTarget() { result = e.getStaticTarget() }

  CfgNode getFunction() { result.getAst() = e.getFunction() }
}

class CallExprCfgNode extends ApplyExprCfgNode {
  override CallExpr e;
}

/** A control-flow node that wraps a key-path application. */
class KeyPathApplicationExprCfgNode extends ExprCfgNode {
  override KeyPathApplicationExpr e;

  /**
   * Gets the control-flow node that wraps the key-path of
   * this control-flow element.
   */
  CfgNode getKeyPath() { result.getAst() = e.getKeyPath() }

  /**
   * Gets the control-flow node that wraps the base of
   * this control-flow element.
   */
  CfgNode getBase() { result.getAst() = e.getBase() }
}

/** A control-flow node that wraps a key-path expression. */
class KeyPathExprCfgNode extends ExprCfgNode {
  override KeyPathExpr e;
}

class EntryNode = Impl::EntryNode;

class ExitNode = Impl::ExitNode;

class AnnotatedExitNode = Impl::AnnotatedExitNode;
