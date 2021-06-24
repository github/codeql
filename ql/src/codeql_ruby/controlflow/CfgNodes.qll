/** Provides classes representing nodes in a control flow graph. */

private import codeql_ruby.AST
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
class AstCfgNode extends CfgNode, TAstCfgNode {
  private Splits splits;
  private AstNode n;

  AstCfgNode() { this = TAstCfgNode(n, splits) }

  final override AstNode getNode() { result = n }

  override Location getLocation() { result = n.getLocation() }

  final override string toString() {
    exists(string s | s = n.(AstNode).toString() |
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

/** A control-flow node that wraps a return-like statement. */
class ReturningCfgNode extends AstCfgNode {
  ReturningStmt s;

  ReturningCfgNode() { s = this.getNode() }

  /** Gets the node of the returned value, if any. */
  ExprCfgNode getReturnedValueNode() {
    result = this.getAPredecessor() and
    result.getNode() = s.getValue()
  }
}

private Expr desugar(Expr n) {
  result = n.getDesugared()
  or
  not exists(n.getDesugared()) and
  result = n
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

  pragma[nomagic]
  private predicate reachesBasicBlock(Expr child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn = this.getAControlFlowNode() and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getAPredecessor() and
      not mid.getANode().getNode() = child
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
    this.reachesBasicBlock(child, cfn, cfnChild.getBasicBlock()) and
    cfnChild = desugar(child).getAControlFlowNode()
  }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  // TODO: Add more classes
  private class AssignExprChildMapping extends ExprChildMapping, AssignExpr {
    override predicate relevantChild(Expr e) { e = this.getAnOperand() }
  }

  /** A control-flow node that wraps an `AssignExpr` AST expression. */
  class AssignExprCfgNode extends ExprCfgNode {
    override AssignExprChildMapping e;

    final override AssignExpr getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the LHS of this assignment. */
    final ExprCfgNode getLhs() { e.hasCfgChild(e.getLeftOperand(), this, result) }

    /** Gets the RHS of this assignment. */
    final ExprCfgNode getRhs() { e.hasCfgChild(e.getRightOperand(), this, result) }
  }

  private class OperationExprChildMapping extends ExprChildMapping, Operation {
    override predicate relevantChild(Expr e) { e = this.getAnOperand() }
  }

  /** A control-flow node that wraps an `Operation` AST expression. */
  class OperationCfgNode extends ExprCfgNode {
    override OperationExprChildMapping e;

    override Operation getExpr() { result = super.getExpr() }

    /** Gets an operand of this operation. */
    final ExprCfgNode getAnOperand() { e.hasCfgChild(e.getAnOperand(), this, result) }
  }

  /** A control-flow node that wraps a `BinaryOperation` AST expression. */
  class BinaryOperationCfgNode extends OperationCfgNode {
    private BinaryOperation bo;

    BinaryOperationCfgNode() { e = bo }

    final override BinaryOperation getExpr() { result = super.getExpr() }

    /** Gets the left operand of this binary operation. */
    final ExprCfgNode getLeftOperand() { e.hasCfgChild(bo.getLeftOperand(), this, result) }

    /** Gets the right operand of this binary operation. */
    final ExprCfgNode getRightOperand() { e.hasCfgChild(bo.getRightOperand(), this, result) }
  }

  private class BlockArgumentChildMapping extends ExprChildMapping, BlockArgument {
    override predicate relevantChild(Expr e) { e = this.getValue() }
  }

  /** A control-flow node that wraps a `BlockArgument` AST expression. */
  class BlockArgumentCfgNode extends ExprCfgNode {
    override BlockArgumentChildMapping e;

    final override BlockArgument getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the value of this block argument. */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }
  }

  private class CallExprChildMapping extends ExprChildMapping, Call {
    override predicate relevantChild(Expr e) {
      e = [this.getAnArgument(), this.(MethodCall).getReceiver(), this.(MethodCall).getBlock()]
    }
  }

  /** A control-flow node that wraps a `Call` AST expression. */
  class CallCfgNode extends ExprCfgNode {
    override CallExprChildMapping e;

    override Call getExpr() { result = super.getExpr() }

    /** Gets the `n`th argument of this call. */
    final ExprCfgNode getArgument(int n) { e.hasCfgChild(e.getArgument(n), this, result) }

    /** Gets the the keyword argument whose key is `keyword` of this call. */
    final ExprCfgNode getKeywordArgument(string keyword) {
      e.hasCfgChild(e.getKeywordArgument(keyword), this, result)
    }

    /** Gets the number of arguments of this call. */
    final int getNumberOfArguments() { result = e.getNumberOfArguments() }

    /** Gets the receiver of this call. */
    final ExprCfgNode getReceiver() { e.hasCfgChild(e.(MethodCall).getReceiver(), this, result) }

    /** Gets the block of this call. */
    final ExprCfgNode getBlock() { e.hasCfgChild(e.(MethodCall).getBlock(), this, result) }
  }

  private class CaseExprChildMapping extends ExprChildMapping, CaseExpr {
    override predicate relevantChild(Expr e) { e = this.getValue() or e = this.getBranch(_) }
  }

  /** A control-flow node that wraps a `MethodCall` AST expression. */
  class MethodCallCfgNode extends CallCfgNode {
    MethodCallCfgNode() { super.getExpr() instanceof MethodCall }

    final override MethodCall getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `CaseExpr` AST expression. */
  class CaseExprCfgNode extends ExprCfgNode {
    override CaseExprChildMapping e;

    final override CaseExpr getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the expression being compared, if any. */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }

    /**
     * Gets the `n`th branch of this case expression.
     */
    final ExprCfgNode getBranch(int n) { e.hasCfgChild(e.getBranch(n), this, result) }
  }

  private class ConditionalExprChildMapping extends ExprChildMapping, ConditionalExpr {
    override predicate relevantChild(Expr e) { e = this.getCondition() or e = this.getBranch(_) }
  }

  /** A control-flow node that wraps a `ConditionalExpr` AST expression. */
  class ConditionalExprCfgNode extends ExprCfgNode {
    override ConditionalExprChildMapping e;

    final override ConditionalExpr getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the condition expression. */
    final ExprCfgNode getCondition() { e.hasCfgChild(e.getCondition(), this, result) }

    /**
     * Gets the branch of this conditional expression that is taken when the condition
     * evaluates to cond, if any.
     */
    final ExprCfgNode getBranch(boolean cond) { e.hasCfgChild(e.getBranch(cond), this, result) }
  }

  private class ConstantAccessChildMapping extends ExprChildMapping, ConstantAccess {
    override predicate relevantChild(Expr e) { e = this.getScopeExpr() }
  }

  /** A control-flow node that wraps a `ConditionalExpr` AST expression. */
  class ConstantAccessCfgNode extends ExprCfgNode {
    override ConstantAccessChildMapping e;

    final override ConstantAccess getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the scope expression. */
    final ExprCfgNode getScopeExpr() { e.hasCfgChild(e.getScopeExpr(), this, result) }
  }

  private class StmtSequenceChildMapping extends ExprChildMapping, StmtSequence {
    override predicate relevantChild(Expr e) { e = this.getLastStmt() }
  }

  /** A control-flow node that wraps a `StmtSequence` AST expression. */
  class StmtSequenceCfgNode extends ExprCfgNode {
    override StmtSequenceChildMapping e;

    final override StmtSequence getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the last statement in this sequence, if any. */
    final ExprCfgNode getLastStmt() { e.hasCfgChild(e.getLastStmt(), this, result) }
  }

  private class ForExprChildMapping extends ExprChildMapping, ForExpr {
    override predicate relevantChild(Expr e) { e = this.getValue() }
  }

  /** A control-flow node that wraps a `ForExpr` AST expression. */
  class ForExprCfgNode extends ExprCfgNode {
    override ForExprChildMapping e;

    final override ForExpr getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the value being iterated over. */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }
  }

  /** A control-flow node that wraps a `ParenthesizedExpr` AST expression. */
  class ParenthesizedExprCfgNode extends StmtSequenceCfgNode {
    ParenthesizedExprCfgNode() { this.getExpr() instanceof ParenthesizedExpr }
  }

  /** A control-flow node that wraps a `VariableReadAccess` AST expression. */
  class VariableReadAccessCfgNode extends ExprCfgNode {
    override VariableReadAccess e;

    final override VariableReadAccess getExpr() { result = ExprCfgNode.super.getExpr() }
  }
}
