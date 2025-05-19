/** Provides classes representing nodes in a control flow graph. */

private import codeql.ruby.AST
private import codeql.ruby.controlflow.BasicBlocks
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.internal.Constant
private import codeql.ruby.ast.internal.Literal
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

  /** Gets the constant value of this expression, if any. */
  ConstantValue getConstantValue() { result = getConstantValue(this) }
}

/** A control-flow node that wraps a return-like statement. */
class ReturningCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "ReturningCfgNode" }

  ReturningStmt s;

  ReturningCfgNode() { s = this.getAstNode() }

  /** Gets the node of the returned value, if any. */
  ExprCfgNode getReturnedValueNode() {
    result = this.getAPredecessor() and
    result.getAstNode() = s.getValue()
  }
}

/** A control-flow node that wraps a `StringComponent` AST expression. */
class StringComponentCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "StringComponentCfgNode" }

  StringComponentCfgNode() { this.getAstNode() instanceof StringComponent }

  /** Gets the constant value of this string component. */
  ConstantValue getConstantValue() {
    result = this.getAstNode().(StringComponent).getConstantValue()
  }
}

/** A control-flow node that wraps a `RegExpComponent` AST expression. */
class RegExpComponentCfgNode extends StringComponentCfgNode {
  override string getAPrimaryQlClass() { result = "RegExpComponentCfgNode" }

  RegExpComponentCfgNode() { this.getAstNode() instanceof RegExpComponent }
}

private AstNode desugar(AstNode n) {
  result = n.getDesugared()
  or
  not exists(n.getDesugared()) and
  result = n
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ChildMapping extends AstNode {
  /**
   * Holds if `child` is a (possibly nested) child of this expression
   * for which we would like to find a matching CFG child.
   */
  abstract predicate relevantChild(AstNode child);

  pragma[nomagic]
  abstract predicate reachesBasicBlock(AstNode child, CfgNode cfn, BasicBlock bb);

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnChild`, where `cfn`
   * is a control-flow node for this expression, and `cfnChild` is a control-flow
   * node for `child`.
   *
   * The path never escapes the syntactic scope of this expression.
   */
  cached
  predicate hasCfgChild(AstNode child, CfgNode cfn, CfgNode cfnChild) {
    this.reachesBasicBlock(child, cfn, cfnChild.getBasicBlock()) and
    cfnChild.getAstNode() = desugar(child)
  }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ExprChildMapping extends Expr, ChildMapping {
  pragma[nomagic]
  override predicate reachesBasicBlock(AstNode child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn = this.getAControlFlowNode() and
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
  override predicate reachesBasicBlock(AstNode child, CfgNode cfn, BasicBlock bb) {
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
  private class LiteralChildMapping extends ExprChildMapping, Literal {
    override predicate relevantChild(AstNode n) { none() }
  }

  /** A control-flow node that wraps a `Literal` AST expression. */
  class LiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "LiteralCfgNode" }

    override LiteralChildMapping e;

    override Literal getExpr() { result = super.getExpr() }
  }

  private class ControlExprChildMapping extends ExprChildMapping, ControlExpr {
    override predicate relevantChild(AstNode n) { none() }
  }

  /** A control-flow node that wraps a `ControlExpr` AST expression. */
  class ControlExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ControlExprCfgNode" }

    override ControlExprChildMapping e;

    override ControlExpr getExpr() { result = super.getExpr() }
  }

  private class LhsExprChildMapping extends ExprChildMapping, LhsExpr {
    override predicate relevantChild(AstNode n) { none() }
  }

  /** A control-flow node that wraps a `LhsExpr` AST expression. */
  class LhsExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "LhsExprCfgNode" }

    override LhsExprChildMapping e;

    override LhsExpr getExpr() { result = super.getExpr() }

    /** Gets the variable used in (or introduced by) this LHS. */
    Variable getVariable() { result = e.(VariableAccess).getVariable() }
  }

  private class AssignExprChildMapping extends ExprChildMapping, AssignExpr {
    override predicate relevantChild(AstNode n) { n = this.getAnOperand() }
  }

  /** A control-flow node that wraps an `AssignExpr` AST expression. */
  class AssignExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "AssignExprCfgNode" }

    override AssignExprChildMapping e;

    final override AssignExpr getExpr() { result = super.getExpr() }

    /** Gets the LHS of this assignment. */
    final LhsExprCfgNode getLhs() { e.hasCfgChild(e.getLeftOperand(), this, result) }

    /** Gets the RHS of this assignment. */
    final ExprCfgNode getRhs() { e.hasCfgChild(e.getRightOperand(), this, result) }
  }

  private class OperationExprChildMapping extends ExprChildMapping, Operation {
    override predicate relevantChild(AstNode n) { n = this.getAnOperand() }
  }

  /** A control-flow node that wraps an `Operation` AST expression. */
  class OperationCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "OperationCfgNode" }

    override OperationExprChildMapping e;

    override Operation getExpr() { result = super.getExpr() }

    /** Gets the operator of this operation. */
    string getOperator() { result = this.getExpr().getOperator() }

    /** Gets an operand of this operation. */
    final ExprCfgNode getAnOperand() { e.hasCfgChild(e.getAnOperand(), this, result) }
  }

  /** A control-flow node that wraps a `UnaryOperation` AST expression. */
  class UnaryOperationCfgNode extends OperationCfgNode {
    override string getAPrimaryQlClass() { result = "UnaryOperationCfgNode" }

    private UnaryOperation uo;

    UnaryOperationCfgNode() { e = uo }

    override UnaryOperation getExpr() { result = super.getExpr() }

    /** Gets the operand of this unary operation. */
    final ExprCfgNode getOperand() { e.hasCfgChild(uo.getOperand(), this, result) }
  }

  /** A control-flow node that wraps a `BinaryOperation` AST expression. */
  class BinaryOperationCfgNode extends OperationCfgNode {
    override string getAPrimaryQlClass() { result = "BinaryOperationCfgNode" }

    private BinaryOperation bo;

    BinaryOperationCfgNode() { e = bo }

    override BinaryOperation getExpr() { result = super.getExpr() }

    /** Gets the left operand of this binary operation. */
    final ExprCfgNode getLeftOperand() { e.hasCfgChild(bo.getLeftOperand(), this, result) }

    /** Gets the right operand of this binary operation. */
    final ExprCfgNode getRightOperand() { e.hasCfgChild(bo.getRightOperand(), this, result) }
  }

  private class BlockArgumentChildMapping extends ExprChildMapping, BlockArgument {
    override predicate relevantChild(AstNode n) { n = this.getValue() }
  }

  /** A control-flow node that wraps a `BlockArgument` AST expression. */
  class BlockArgumentCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "BlockArgumentCfgNode" }

    override BlockArgumentChildMapping e;

    final override BlockArgument getExpr() { result = super.getExpr() }

    /** Gets the value of this block argument. */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }
  }

  private class CallExprChildMapping extends ExprChildMapping, Call {
    override predicate relevantChild(AstNode n) {
      n = [this.getAnArgument(), this.(MethodCall).getReceiver(), this.(MethodCall).getBlock()]
    }
  }

  /** A control-flow node that wraps a `Call` AST expression. */
  class CallCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override CallExprChildMapping e;

    override Call getExpr() { result = super.getExpr() }

    /** Gets the `n`th argument of this call. */
    final ExprCfgNode getArgument(int n) { e.hasCfgChild(e.getArgument(n), this, result) }

    /** Gets an argument of this call. */
    final ExprCfgNode getAnArgument() { result = this.getArgument(_) }

    /** Gets the keyword argument whose key is `keyword` of this call. */
    final ExprCfgNode getKeywordArgument(string keyword) {
      exists(PairCfgNode n |
        e.hasCfgChild(e.getAnArgument(), this, n) and
        n.getKey().getExpr().getConstantValue().isSymbol(keyword) and
        result = n.getValue()
      )
    }

    /**
     * Gets the `n`th positional argument of this call.
     * Unlike `getArgument`, this excludes keyword arguments.
     */
    final ExprCfgNode getPositionalArgument(int n) {
      result = this.getArgument(n) and not result instanceof PairCfgNode
    }

    /** Gets the number of arguments of this call. */
    final int getNumberOfArguments() { result = e.getNumberOfArguments() }

    /** Gets the receiver of this call. */
    final ExprCfgNode getReceiver() { e.hasCfgChild(e.(MethodCall).getReceiver(), this, result) }

    /** Gets the block of this call. */
    final ExprCfgNode getBlock() { e.hasCfgChild(e.(MethodCall).getBlock(), this, result) }
  }

  /** A control-flow node that wraps a `MethodCall` AST expression. */
  class MethodCallCfgNode extends CallCfgNode {
    override string getAPrimaryQlClass() { result = "MethodCallCfgNode" }

    MethodCallCfgNode() { super.getExpr() instanceof MethodCall }

    override MethodCall getExpr() { result = super.getExpr() }

    /** Gets the name of this method call. */
    string getMethodName() { result = this.getExpr().getMethodName() }
  }

  private class CaseExprChildMapping extends ExprChildMapping, CaseExpr {
    override predicate relevantChild(AstNode e) { e = this.getValue() or e = this.getABranch() }
  }

  /** A control-flow node that wraps a `CaseExpr` AST expression. */
  class CaseExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "CaseExprCfgNode" }

    override CaseExprChildMapping e;

    final override CaseExpr getExpr() { result = super.getExpr() }

    /** Gets the expression being compared, if any. */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }

    /**
     * Gets the `n`th branch of this case expression, either a `when` clause, an `in` clause, or an `else` branch.
     */
    final AstCfgNode getBranch(int n) { e.hasCfgChild(e.getBranch(n), this, result) }
  }

  private class InClauseChildMapping extends NonExprChildMapping, InClause {
    override predicate relevantChild(AstNode e) {
      e = this.getPattern() or
      e = this.getCondition() or
      e = this.getBody()
    }
  }

  /** A control-flow node that wraps an `InClause` AST expression. */
  class InClauseCfgNode extends AstCfgNode {
    private InClauseChildMapping e;

    InClauseCfgNode() { e = this.getAstNode() }

    override string getAPrimaryQlClass() { result = "InClauseCfgNode" }

    /** Gets the pattern in this `in`-clause. */
    final AstCfgNode getPattern() { e.hasCfgChild(e.getPattern(), this, result) }

    /** Gets the pattern guard condition in this `in` clause, if any. */
    final ExprCfgNode getCondition() { e.hasCfgChild(e.getCondition(), this, result) }

    /** Gets the body of this `in`-clause. */
    final ExprCfgNode getBody() { e.hasCfgChild(e.getBody(), this, result) }
  }

  // `when` clauses need special treatment, since they are neither pre-order
  // nor post-order
  private class WhenClauseChildMapping extends WhenClause {
    predicate patternReachesBasicBlock(int i, CfgNode cfnPattern, BasicBlock bb) {
      exists(Expr pattern |
        pattern = this.getPattern(i) and
        cfnPattern.getAstNode() = pattern and
        bb.getANode() = cfnPattern
      )
      or
      exists(BasicBlock mid |
        this.patternReachesBasicBlock(i, cfnPattern, mid) and
        bb = mid.getASuccessor() and
        not mid.getANode().getAstNode() = this
      )
    }

    predicate bodyReachesBasicBlock(CfgNode cfnBody, BasicBlock bb) {
      exists(Stmt body |
        body = this.getBody() and
        cfnBody.getAstNode() = body and
        bb.getANode() = cfnBody
      )
      or
      exists(BasicBlock mid |
        this.bodyReachesBasicBlock(cfnBody, mid) and
        bb = mid.getAPredecessor() and
        not mid.getANode().getAstNode() = this
      )
    }
  }

  /** A control-flow node that wraps a `WhenClause` AST expression. */
  class WhenClauseCfgNode extends AstCfgNode {
    private WhenClauseChildMapping e;

    WhenClauseCfgNode() { e = this.getAstNode() }

    override string getAPrimaryQlClass() { result = "WhenClauseCfgNode" }

    /** Gets the body of this `when`-clause. */
    final ExprCfgNode getBody() {
      result.getAstNode() = desugar(e.getBody()) and
      e.bodyReachesBasicBlock(result, this.getBasicBlock())
    }

    /** Gets the `i`th pattern this `when`-clause. */
    final ExprCfgNode getPattern(int i) {
      result.getAstNode() = desugar(e.getPattern(i)) and
      e.patternReachesBasicBlock(i, result, this.getBasicBlock())
    }
  }

  /** A control-flow node that wraps a `CasePattern`. */
  class CasePatternCfgNode extends AstCfgNode {
    CasePattern e;

    CasePatternCfgNode() { e = this.getAstNode() }

    override string getAPrimaryQlClass() { result = "CasePatternCfgNode" }
  }

  private class ArrayPatternChildMapping extends NonExprChildMapping, ArrayPattern {
    override predicate relevantChild(AstNode e) {
      e = this.getPrefixElement(_) or
      e = this.getSuffixElement(_) or
      e = this.getRestVariableAccess()
    }
  }

  /** A control-flow node that wraps an `ArrayPattern` node. */
  class ArrayPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayPatternCfgNode" }

    override ArrayPatternChildMapping e;

    /** Gets the `n`th element of this list pattern's prefix. */
    final CasePatternCfgNode getPrefixElement(int n) {
      e.hasCfgChild(e.getPrefixElement(n), this, result)
    }

    /** Gets the `n`th element of this list pattern's suffix. */
    final CasePatternCfgNode getSuffixElement(int n) {
      e.hasCfgChild(e.getSuffixElement(n), this, result)
    }

    /** Gets the variable of the rest token, if any. */
    final VariableWriteAccessCfgNode getRestVariableAccess() {
      e.hasCfgChild(e.getRestVariableAccess(), this, result)
    }
  }

  private class FindPatternChildMapping extends NonExprChildMapping, FindPattern {
    override predicate relevantChild(AstNode e) {
      e = this.getElement(_) or
      e = this.getPrefixVariableAccess() or
      e = this.getSuffixVariableAccess()
    }
  }

  /** A control-flow node that wraps a `FindPattern` node. */
  class FindPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "FindPatternCfgNode" }

    override FindPatternChildMapping e;

    /** Gets the `n`th element of this find pattern. */
    final CasePatternCfgNode getElement(int n) { e.hasCfgChild(e.getElement(n), this, result) }

    /** Gets the variable for the prefix of this find pattern, if any. */
    final VariableWriteAccessCfgNode getPrefixVariableAccess() {
      e.hasCfgChild(e.getPrefixVariableAccess(), this, result)
    }

    /** Gets the variable for the suffix of this find pattern, if any. */
    final VariableWriteAccessCfgNode getSuffixVariableAccess() {
      e.hasCfgChild(e.getSuffixVariableAccess(), this, result)
    }
  }

  private class HashPatternChildMapping extends NonExprChildMapping, HashPattern {
    override predicate relevantChild(AstNode e) {
      e = this.getValue(_) or
      e = this.getRestVariableAccess()
    }
  }

  /** A control-flow node that wraps a `HashPattern` node. */
  class HashPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "HashPatternCfgNode" }

    override HashPatternChildMapping e;

    /** Gets the value of the `n`th pair. */
    final CasePatternCfgNode getValue(int n) { e.hasCfgChild(e.getValue(n), this, result) }

    /** Gets the variable of the keyword rest token, if any. */
    final VariableWriteAccessCfgNode getRestVariableAccess() {
      e.hasCfgChild(e.getRestVariableAccess(), this, result)
    }
  }

  private class AlternativePatternChildMapping extends NonExprChildMapping, AlternativePattern {
    override predicate relevantChild(AstNode e) { e = this.getAnAlternative() }
  }

  /** A control-flow node that wraps an `AlternativePattern` node. */
  class AlternativePatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "AlternativePatternCfgNode" }

    override AlternativePatternChildMapping e;

    /** Gets the `n`th alternative. */
    final CasePatternCfgNode getAlternative(int n) {
      e.hasCfgChild(e.getAlternative(n), this, result)
    }
  }

  private class AsPatternChildMapping extends NonExprChildMapping, AsPattern {
    override predicate relevantChild(AstNode e) {
      e = this.getPattern() or e = this.getVariableAccess()
    }
  }

  /** A control-flow node that wraps an `AsPattern` node. */
  class AsPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "AsPatternCfgNode" }

    override AsPatternChildMapping e;

    /** Gets the underlying pattern. */
    final CasePatternCfgNode getPattern() { e.hasCfgChild(e.getPattern(), this, result) }

    /** Gets the variable access for this pattern. */
    final VariableWriteAccessCfgNode getVariableAccess() {
      e.hasCfgChild(e.getVariableAccess(), this, result)
    }
  }

  private class ParenthesizedPatternChildMapping extends NonExprChildMapping, ParenthesizedPattern {
    override predicate relevantChild(AstNode e) { e = this.getPattern() }
  }

  /** A control-flow node that wraps a `ParenthesizedPattern` node. */
  class ParenthesizedPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "ParenthesizedPatternCfgNode" }

    override ParenthesizedPatternChildMapping e;

    /** Gets the underlying pattern. */
    final CasePatternCfgNode getPattern() { e.hasCfgChild(e.getPattern(), this, result) }
  }

  private class ConditionalExprChildMapping extends ExprChildMapping, ConditionalExpr {
    override predicate relevantChild(AstNode n) { n = [this.getCondition(), this.getBranch(_)] }
  }

  /** A control-flow node that wraps a `ConditionalExpr` AST expression. */
  class ConditionalExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConditionalExprCfgNode" }

    override ConditionalExprChildMapping e;

    final override ConditionalExpr getExpr() { result = super.getExpr() }

    /** Gets the condition expression. */
    final ExprCfgNode getCondition() { e.hasCfgChild(e.getCondition(), this, result) }

    /**
     * Gets the branch of this conditional expression that is taken when the condition
     * evaluates to cond, if any.
     */
    final ExprCfgNode getBranch(boolean cond) { e.hasCfgChild(e.getBranch(cond), this, result) }
  }

  private class ConstantAccessChildMapping extends ExprChildMapping, ConstantAccess {
    override predicate relevantChild(AstNode n) { n = this.getScopeExpr() }
  }

  /** A control-flow node that wraps a `ConditionalExpr` AST expression. */
  class ConstantAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConstantAccessCfgNode" }

    override ConstantAccessChildMapping e;

    final override ConstantAccess getExpr() { result = super.getExpr() }

    /** Gets the scope expression. */
    final ExprCfgNode getScopeExpr() { e.hasCfgChild(e.getScopeExpr(), this, result) }
  }

  private class StmtSequenceChildMapping extends ExprChildMapping, StmtSequence {
    override predicate relevantChild(AstNode n) { n = this.getLastStmt() }
  }

  /** A control-flow node that wraps a `StmtSequence` AST expression. */
  class StmtSequenceCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "StmtSequenceCfgNode" }

    override StmtSequenceChildMapping e;

    final override StmtSequence getExpr() { result = super.getExpr() }

    /** Gets the last statement in this sequence, if any. */
    final ExprCfgNode getLastStmt() { e.hasCfgChild(e.getLastStmt(), this, result) }
  }

  private class ForExprChildMapping extends ExprChildMapping, ForExpr {
    override predicate relevantChild(AstNode n) { n = this.getValue() }
  }

  /** A control-flow node that wraps a `ForExpr` AST expression. */
  class ForExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ForExprCfgNode" }

    override ForExprChildMapping e;

    final override ForExpr getExpr() { result = super.getExpr() }

    /** Gets the value being iterated over. */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }
  }

  /** A control-flow node that wraps a `ParenthesizedExpr` AST expression. */
  class ParenthesizedExprCfgNode extends StmtSequenceCfgNode {
    override string getAPrimaryQlClass() { result = "ParenthesizedExprCfgNode" }

    ParenthesizedExprCfgNode() { this.getExpr() instanceof ParenthesizedExpr }
  }

  private class PairChildMapping extends ExprChildMapping, Pair {
    override predicate relevantChild(AstNode n) { n = [this.getKey(), this.getValue()] }
  }

  /** A control-flow node that wraps a `Pair` AST expression. */
  class PairCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "PairCfgNode" }

    override PairChildMapping e;

    final override Pair getExpr() { result = super.getExpr() }

    /**
     * Gets the key expression of this pair.
     */
    final ExprCfgNode getKey() { e.hasCfgChild(e.getKey(), this, result) }

    /**
     * Gets the value expression of this pair.
     */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }
  }

  /** A control-flow node that wraps a `VariableAccess` AST expression. */
  class VariableAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "VariableAccessCfgNode" }

    override VariableAccess e;

    override VariableAccess getExpr() { result = super.getExpr() }

    /** Gets the variable that is being accessed. */
    Variable getVariable() { result = this.getExpr().getVariable() }
  }

  /** A control-flow node that wraps a `VariableReadAccess` AST expression. */
  class VariableReadAccessCfgNode extends VariableAccessCfgNode {
    override string getAPrimaryQlClass() { result = "VariableReadAccessCfgNode" }

    override VariableReadAccess e;

    override VariableReadAccess getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `LocalVariableReadAccess` AST expression. */
  class LocalVariableReadAccessCfgNode extends VariableReadAccessCfgNode {
    override string getAPrimaryQlClass() { result = "LocalVariableReadAccessCfgNode" }

    override LocalVariableReadAccess e;

    final override LocalVariableReadAccess getExpr() { result = super.getExpr() }

    final override LocalVariable getVariable() { result = super.getVariable() }
  }

  private class InstanceVariableAccessMapping extends ExprChildMapping, InstanceVariableAccess {
    override predicate relevantChild(AstNode n) { n = this.getReceiver() }
  }

  /** A control-flow node that wraps an `InstanceVariableAccess` AST expression. */
  class InstanceVariableAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "InstanceVariableAccessCfgNode" }

    override InstanceVariableAccessMapping e;

    override InstanceVariableAccess getExpr() { result = super.getExpr() }

    /**
     * Gets the synthetic receiver (`self`) of this instance variable access.
     */
    final CfgNode getReceiver() { e.hasCfgChild(e.getReceiver(), this, result) }
  }

  private class SelfVariableAccessMapping extends ExprChildMapping, SelfVariableAccess {
    override predicate relevantChild(AstNode n) { none() }
  }

  /** A control-flow node that wraps a `SelfVariableAccess` AST expression. */
  class SelfVariableAccessCfgNode extends VariableAccessCfgNode {
    final override string getAPrimaryQlClass() { result = "SelfVariableAccessCfgNode" }

    override SelfVariableAccessMapping e;

    override SelfVariableAccess getExpr() { result = super.getExpr() }
  }

  private class VariableWriteAccessChildMapping extends ExprChildMapping, VariableWriteAccess {
    override predicate relevantChild(AstNode n) { this.isExplicitWrite(n) }
  }

  /** A control-flow node that wraps a `VariableWriteAccess` AST expression. */
  class VariableWriteAccessCfgNode extends VariableAccessCfgNode {
    /**
     * Holds if this access is a write access belonging to the explicit
     * assignment `assignment`. For example, in
     *
     * ```rb
     * a = foo
     * ```
     *
     * both `a` is write accesses belonging to the assignment `a = foo`.
     */
    predicate isExplicitWrite(AssignExprCfgNode assignment) { this = assignment.getLhs() }

    /**
     * Holds if this access is a write access belonging to an implicit assignment.
     */
    predicate isImplicitWrite() { e.isImplicitWrite() }

    override string getAPrimaryQlClass() { result = "VariableWriteAccessCfgNode" }

    override VariableWriteAccessChildMapping e;

    override VariableWriteAccess getExpr() { result = super.getExpr() }
  }

  private class LocalVariableWriteAccessChildMapping extends VariableWriteAccessChildMapping,
    LocalVariableWriteAccess
  { }

  /** A control-flow node that wraps a `LocalVariableWriteAccess` AST expression. */
  class LocalVariableWriteAccessCfgNode extends VariableWriteAccessCfgNode {
    override string getAPrimaryQlClass() { result = "LocalVariableWriteAccessCfgNode" }

    override LocalVariableWriteAccessChildMapping e;

    final override LocalVariableWriteAccess getExpr() { result = super.getExpr() }

    final override LocalVariable getVariable() { result = super.getVariable() }
  }

  /** A control-flow node that wraps a `ConstantReadAccess` AST expression. */
  class ConstantReadAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConstantReadAccessCfgNode" }

    override ConstantReadAccess e;

    final override ConstantReadAccess getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `ConstantWriteAccess` AST expression. */
  class ConstantWriteAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConstantWriteAccessCfgNode" }

    override ConstantWriteAccess e;

    final override ConstantWriteAccess getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps an `InstanceVariableReadAccess` AST expression. */
  class InstanceVariableReadAccessCfgNode extends InstanceVariableAccessCfgNode {
    InstanceVariableReadAccessCfgNode() { this.getAstNode() instanceof InstanceVariableReadAccess }

    override string getAPrimaryQlClass() { result = "InstanceVariableReadAccessCfgNode" }

    final override InstanceVariableReadAccess getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps an `InstanceVariableWriteAccess` AST expression. */
  class InstanceVariableWriteAccessCfgNode extends InstanceVariableAccessCfgNode {
    InstanceVariableWriteAccessCfgNode() {
      this.getAstNode() instanceof InstanceVariableWriteAccess
    }

    override string getAPrimaryQlClass() { result = "InstanceVariableWriteAccessCfgNode" }

    final override InstanceVariableWriteAccess getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `StringInterpolationComponent` AST expression. */
  class StringInterpolationComponentCfgNode extends StringComponentCfgNode, StmtSequenceCfgNode {
    override string getAPrimaryQlClass() { result = "StringInterpolationComponentCfgNode" }

    StringInterpolationComponentCfgNode() {
      this.getAstNode() instanceof StringInterpolationComponent
    }

    final override ConstantValue getConstantValue() {
      result = StmtSequenceCfgNode.super.getConstantValue()
    }
  }

  /** A control-flow node that wraps a `RegExpInterpolationComponent` AST expression. */
  class RegExpInterpolationComponentCfgNode extends RegExpComponentCfgNode, StmtSequenceCfgNode {
    override string getAPrimaryQlClass() { result = "RegExpInterpolationComponentCfgNode" }

    RegExpInterpolationComponentCfgNode() {
      this.getAstNode() instanceof RegExpInterpolationComponent
    }

    final override ConstantValue getConstantValue() {
      result = StmtSequenceCfgNode.super.getConstantValue()
    }
  }

  private class StringlikeLiteralChildMapping extends ExprChildMapping, StringlikeLiteral {
    override predicate relevantChild(AstNode n) { n = this.getComponent(_) }
  }

  /** A control-flow node that wraps a `StringlikeLiteral` AST expression. */
  class StringlikeLiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "StringlikeLiteralCfgNode" }

    override StringlikeLiteralChildMapping e;

    override StringlikeLiteral getExpr() { result = super.getExpr() }

    /** Gets the `n`th component of this `StringlikeLiteral` */
    StringComponentCfgNode getComponent(int n) { e.hasCfgChild(e.getComponent(n), this, result) }

    /** Gets a component of this `StringlikeLiteral` */
    StringComponentCfgNode getAComponent() { result = this.getComponent(_) }
  }

  /** A control-flow node that wraps a `StringLiteral` AST expression. */
  class StringLiteralCfgNode extends StringlikeLiteralCfgNode {
    StringLiteralCfgNode() { e instanceof StringLiteral }

    override string getAPrimaryQlClass() { result = "StringLiteralCfgNode" }

    final override StringLiteral getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `RegExpLiteral` AST expression. */
  class RegExpLiteralCfgNode extends StringlikeLiteralCfgNode {
    override string getAPrimaryQlClass() { result = "RegExpLiteralCfgNode" }

    RegExpLiteralCfgNode() { e instanceof RegExpLiteral }

    final override RegExpComponentCfgNode getComponent(int n) { result = super.getComponent(n) }

    final override RegExpComponentCfgNode getAComponent() { result = super.getAComponent() }

    final override RegExpLiteral getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `ComparisonOperation` AST expression. */
  class ComparisonOperationCfgNode extends BinaryOperationCfgNode {
    override string getAPrimaryQlClass() { result = "ComparisonOperationCfgNode" }

    ComparisonOperationCfgNode() { e instanceof ComparisonOperation }

    override ComparisonOperation getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `RelationalOperation` AST expression. */
  class RelationalOperationCfgNode extends ComparisonOperationCfgNode {
    override string getAPrimaryQlClass() { result = "RelationalOperationCfgNode" }

    RelationalOperationCfgNode() { e instanceof RelationalOperation }

    final override RelationalOperation getExpr() { result = super.getExpr() }
  }

  private class SplatExprChildMapping extends OperationExprChildMapping, SplatExpr {
    override predicate relevantChild(AstNode n) { n = this.getOperand() }
  }

  /** A control-flow node that wraps a `SplatExpr` AST expression. */
  class SplatExprCfgNode extends UnaryOperationCfgNode {
    override string getAPrimaryQlClass() { result = "SplatExprCfgNode" }

    override SplatExprChildMapping e;

    final override SplatExpr getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps an `ElementReference` AST expression. */
  class ElementReferenceCfgNode extends MethodCallCfgNode {
    override string getAPrimaryQlClass() { result = "ElementReferenceCfgNode" }

    ElementReferenceCfgNode() { e instanceof ElementReference }

    final override ElementReference getExpr() { result = super.getExpr() }
  }

  /**
   * A control-flow node that wraps an array literal. Array literals are desugared
   * into calls to `Array.[]`, so this includes both desugared calls as well as
   * explicit calls.
   */
  class ArrayLiteralCfgNode extends MethodCallCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayLiteralCfgNode" }

    ArrayLiteralCfgNode() {
      exists(ConstantReadAccess array |
        array = this.getReceiver().getExpr() and
        e.(MethodCall).getMethodName() = "[]" and
        array.getModule().getQualifiedName() = "Array"
      )
    }
  }

  /**
   * A control-flow node that wraps a hash literal. Hash literals are desugared
   * into calls to `Hash.[]`, so this includes both desugared calls as well as
   * explicit calls.
   */
  class HashLiteralCfgNode extends MethodCallCfgNode {
    override string getAPrimaryQlClass() { result = "HashLiteralCfgNode" }

    HashLiteralCfgNode() {
      exists(ConstantReadAccess hash |
        hash = this.getReceiver().getExpr() and
        e.(MethodCall).getMethodName() = "[]" and
        hash.getModule().getQualifiedName() = "Hash"
      )
    }

    /** Gets a pair of this hash literal. */
    PairCfgNode getAKeyValuePair() { result = this.getAnArgument() }
  }
}
