/** Provides classes representing nodes in a control flow graph. */

private import powershell
private import BasicBlocks
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl

/** An entry node for a given scope. */
class EntryNode extends CfgNode, CfgImpl::EntryNode {
  override string getAPrimaryQlClass() { result = "EntryNode" }

  final override EntryBasicBlock getBasicBlock() { result = super.getBasicBlock() }
}

/** An exit node for a given scope, annotated with the type of exit. */
class AnnotatedExitNode extends CfgNode, CfgImpl::AnnotatedExitNode {
  override string getAPrimaryQlClass() { result = "AnnotatedExitNode" }

  final override AnnotatedExitBasicBlock getBasicBlock() { result = super.getBasicBlock() }
}

/** An exit node for a given scope. */
class ExitNode extends CfgNode, CfgImpl::ExitNode {
  override string getAPrimaryQlClass() { result = "ExitNode" }
}

/**
 * A node for an AST node.
 *
 * Each AST node maps to zero or more `AstCfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class AstCfgNode extends CfgNode, CfgImpl::AstCfgNode {
  /** Gets the name of the primary QL class for this node. */
  override string getAPrimaryQlClass() { result = "AstCfgNode" }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "ExprCfgNode" }

  Expr e;

  ExprCfgNode() { e = this.getAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

/** A control-flow node that wraps an AST statement. */
class StmtCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "StmtCfgNode" }

  Stmt s;

  StmtCfgNode() { s = this.getAstNode() }

  /** Gets the underlying expression. */
  Stmt getStmt() { result = s }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes { }

module StmtNodes {
  /** A control-flow node that wraps a `Cmd` AST expression. */
  class CallCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override Cmd s;

    override Cmd getStmt() { result = super.getStmt() }
  }
}
