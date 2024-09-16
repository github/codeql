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

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ChildMapping extends Ast {
  /**
   * Holds if `child` is a (possibly nested) child of this expression
   * for which we would like to find a matching CFG child.
   */
  abstract predicate relevantChild(Ast child);

  pragma[nomagic]
  abstract predicate reachesBasicBlock(Ast child, CfgNode cfn, BasicBlock bb);

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnChild`, where `cfn`
   * is a control-flow node for this expression, and `cfnChild` is a control-flow
   * node for `child`.
   *
   * The path never escapes the syntactic scope of this expression.
   */
  cached
  predicate hasCfgChild(Ast child, CfgNode cfn, CfgNode cfnChild) {
    this.reachesBasicBlock(child, cfn, cfnChild.getBasicBlock()) and
    cfnChild.getAstNode() = child
  }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ExprChildMapping extends Expr, ChildMapping {
  pragma[nomagic]
  override predicate reachesBasicBlock(Ast child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn.getAstNode() = this and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getAPredecessor() and
      not mid.getANode().getAstNode() = child
    )
  }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class NonExprChildMapping extends ChildMapping {
  NonExprChildMapping() { not this instanceof Expr }

  pragma[nomagic]
  override predicate reachesBasicBlock(Ast child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn.getAstNode() = this and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getASuccessor() and
      not mid.getANode().getAstNode() = child
    )
  }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  private class VarAccessChildMapping extends ExprChildMapping, VarAccess {
    override predicate relevantChild(Ast n) { none() }
  }

  class VarAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "VarAccessCfgNode" }

    override VarAccessChildMapping e;

    override VarAccess getExpr() { result = super.getExpr() }
  }

  private class VarReadAccessChildMapping extends VarAccessChildMapping, VarReadAccess { }

  class VarReadAccessCfgNode extends VarAccessCfgNode {
    override string getAPrimaryQlClass() { result = "VarReadAccessCfgNode" }

    override VarReadAccessChildMapping e;

    override VarReadAccess getExpr() { result = super.getExpr() }
  }

  private class VarWriteAccessChildMapping extends VarAccessChildMapping, VarWriteAccess { }

  class VarWriteAccessCfgNode extends VarAccessCfgNode {
    override string getAPrimaryQlClass() { result = "VarWriteAccessCfgNode" }

    override VarWriteAccessChildMapping e;

    override VarWriteAccess getExpr() { result = super.getExpr() }

    Variable getVariable() { result = e.getVariable() }

    predicate isExplicitWrite(StmtNodes::AssignStmtCfgNode assignment) {
      this = assignment.getLeftHandSide()
    }

    predicate isImplicitWrite() { e.isImplicit() }
  }
}

module StmtNodes {
  private class CmdChildMapping extends NonExprChildMapping, Cmd {
    override predicate relevantChild(Ast n) { n = this.getElement(_) }
  }

  /** A control-flow node that wraps a `Cmd` AST expression. */
  class CmdCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "CmdCfgNode" }

    override CmdChildMapping s;

    override Cmd getStmt() { result = super.getStmt() }
  }

  private class AssignStmtChildMapping extends NonExprChildMapping, AssignStmt {
    override predicate relevantChild(Ast n) {
      n = this.getLeftHandSide() or n = this.getRightHandSide()
    }
  }

  /** A control-flow node that wraps an `AssignStmt` AST expression. */
  class AssignStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "AssignCfgNode" }

    override AssignStmtChildMapping s;

    override AssignStmt getStmt() { result = super.getStmt() }

    /** Gets the LHS of this assignment. */
    final ExprCfgNode getLeftHandSide() { s.hasCfgChild(s.getLeftHandSide(), this, result) }

    /** Gets the RHS of this assignment. */
    final StmtCfgNode getRightHandSide() { s.hasCfgChild(s.getRightHandSide(), this, result) }
  }
}
