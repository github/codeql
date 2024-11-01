/**
 * Provides subclasses of `CfgNode` that represents different types of nodes in
 * the control flow graph.
 */

private import rust
private import ControlFlowGraph

/** A CFG node that corresponds to an element in the AST. */
class AstCfgNode extends CfgNode {
  AstCfgNode() { exists(this.getAstNode()) }
}

/** A CFG node that corresponds to an expression in the AST. */
class ExprCfgNode extends AstCfgNode {
  ExprCfgNode() { this.getAstNode() instanceof Expr }

  /** Gets the underlying expression. */
  Expr getExpr() { result = this.getAstNode() }
}
