/**
 * Provides subclasses of `CfgNode` that represents different types of nodes in
 * the control flow graph.
 */

private import rust
private import ControlFlowGraph

/** A CFG node that corresponds to an element in the AST. */
class AstCfgNode extends CfgNode {
  AstNode node;
  
  AstCfgNode() { node = this.getAstNode() }
}

/** A CFG node that corresponds to an expression in the AST. */
class ExprCfgNode extends AstCfgNode {
  override Expr node;

  /** Gets the underlying expression. */
  Expr getExpr() { result = node }
}
