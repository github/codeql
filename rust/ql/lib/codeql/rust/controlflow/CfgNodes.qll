/**
 * Provides subclasses of `CfgNode` that represents different types of nodes in
 * the control flow graph.
 */

private import rust
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl

/** A CFG node that corresponds to an element in the AST. */
class AstCfgNode extends CfgNode {
  AstNode node;

  AstCfgNode() { node = this.getAstNode() }
}

/** A CFG node that corresponds to a parameter in the AST. */
class ParamCfgNode extends AstCfgNode {
  override Param node;

  /** Gets the underlying parameter. */
  Param getParam() { result = node }
}

/** A CFG node that corresponds to an expression in the AST. */
class ExprCfgNode extends AstCfgNode {
  override Expr node;

  /** Gets the underlying expression. */
  Expr getExpr() { result = node }
}

/** A CFG node that corresponds to a call in the AST. */
class CallExprCfgNode extends ExprCfgNode {
  override CallExpr node;

  /** Gets the underlying `CallExpr`. */
  CallExpr getCallExpr() { result = node }
}

/** A CFG node that corresponds to a call in the AST. */
class MethodCallExprCfgNode extends ExprCfgNode {
  override MethodCallExpr node;

  /** Gets the underlying `MethodCallExpr`. */
  MethodCallExpr getMethodCallExpr() { result = node }
}

final class ExitCfgNode = ExitNode;
