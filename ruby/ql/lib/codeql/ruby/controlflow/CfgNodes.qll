/** Provides classes representing nodes in a control flow graph. */
overlay[local]
module;

private import codeql.ruby.AST
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.internal.Constant
private import ControlFlowGraph

/**
 * A node for an AST node.
 *
 * Each AST node maps to zero or more `AstCfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class AstCfgNode extends CfgNode {
  AstCfgNode() { this.injects(_) }

  AstNode getAstNode() { this.injects(result) }

  /** Gets the name of the primary QL class for this node. */
  overlay[global]
  override string getAPrimaryQlClass() { result = "AstCfgNode" }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends AstCfgNode {
  overlay[global]
  override string getAPrimaryQlClass() { result = "ExprCfgNode" }

  Expr e;

  ExprCfgNode() { e = this.getAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }

  /** Gets the constant value of this expression, if any. */
  overlay[global]
  ConstantValue getConstantValue() { result = getConstantValue(this) }
}

/** A control-flow node that wraps a return-like statement. */
class ReturningCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "ReturningCfgNode" }

  ReturningStmt s;

  ReturningCfgNode() { s = this.getAstNode() }

  /** Gets the node of the returned value, if any. */
  ExprCfgNode getReturnedValueNode() { result.getAstNode() = s.getValue() }
}

/** A control-flow node that wraps a `StringComponent` AST expression. */
class StringComponentCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "StringComponentCfgNode" }

  StringComponentCfgNode() { this.getAstNode() instanceof StringComponent }

  /** Gets the constant value of this string component. */
  overlay[global]
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

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  /** A control-flow node that wraps a `Literal` AST expression. */
  class LiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "LiteralCfgNode" }

    override Literal e;

    override Literal getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `ControlExpr` AST expression. */
  class ControlExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ControlExprCfgNode" }

    override ControlExpr e;

    override ControlExpr getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `LhsExpr` AST expression. */
  class LhsExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "LhsExprCfgNode" }

    override LhsExpr e;

    override LhsExpr getExpr() { result = super.getExpr() }

    /** Gets the variable used in (or introduced by) this LHS. */
    Variable getVariable() { result = e.(VariableAccess).getVariable() }
  }

  /** A control-flow node that wraps an `AssignExpr` AST expression. */
  class AssignExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "AssignExprCfgNode" }

    override AssignExpr e;

    final override AssignExpr getExpr() { result = super.getExpr() }

    /** Gets the LHS of this assignment. */
    final LhsExprCfgNode getLhs() { result.injects(desugar(e.getLeftOperand())) }

    /** Gets the RHS of this assignment. */
    final ExprCfgNode getRhs() { result.injects(desugar(e.getRightOperand())) }
  }

  /** A control-flow node that wraps an `Operation` AST expression. */
  class OperationCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "OperationCfgNode" }

    override Operation e;

    override Operation getExpr() { result = super.getExpr() }

    /** Gets the operator of this operation. */
    string getOperator() { result = this.getExpr().getOperator() }

    /** Gets an operand of this operation. */
    final ExprCfgNode getAnOperand() { result.injects(desugar(e.getAnOperand())) }
  }

  /** A control-flow node that wraps a `UnaryOperation` AST expression. */
  class UnaryOperationCfgNode extends OperationCfgNode {
    override string getAPrimaryQlClass() { result = "UnaryOperationCfgNode" }

    private UnaryOperation uo;

    UnaryOperationCfgNode() { e = uo }

    override UnaryOperation getExpr() { result = super.getExpr() }

    /** Gets the operand of this unary operation. */
    final ExprCfgNode getOperand() { result.injects(desugar(uo.getOperand())) }
  }

  /** A control-flow node that wraps a `BinaryOperation` AST expression. */
  class BinaryOperationCfgNode extends OperationCfgNode {
    override string getAPrimaryQlClass() { result = "BinaryOperationCfgNode" }

    private BinaryOperation bo;

    BinaryOperationCfgNode() { e = bo }

    override BinaryOperation getExpr() { result = super.getExpr() }

    /** Gets the left operand of this binary operation. */
    final ExprCfgNode getLeftOperand() { result.injects(desugar(bo.getLeftOperand())) }

    /** Gets the right operand of this binary operation. */
    final ExprCfgNode getRightOperand() { result.injects(desugar(bo.getRightOperand())) }
  }

  /** A control-flow node that wraps a `BlockArgument` AST expression. */
  class BlockArgumentCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "BlockArgumentCfgNode" }

    override BlockArgument e;

    final override BlockArgument getExpr() { result = super.getExpr() }

    /** Gets the value of this block argument. */
    final ExprCfgNode getValue() { result.injects(desugar(e.getValue())) }
  }

  /** A control-flow node that wraps a `Call` AST expression. */
  class CallCfgNode extends ExprCfgNode {
    overlay[global]
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override Call e;

    override Call getExpr() { result = super.getExpr() }

    /** Gets the `n`th argument of this call. */
    final ExprCfgNode getArgument(int n) { result.injects(desugar(e.getArgument(n))) }

    /** Gets an argument of this call. */
    final ExprCfgNode getAnArgument() { result = this.getArgument(_) }

    /** Gets the keyword argument whose key is `keyword` of this call. */
    overlay[global]
    final ExprCfgNode getKeywordArgument(string keyword) {
      exists(PairCfgNode n |
        n.injects(desugar(e.getAnArgument())) and
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
    final ExprCfgNode getReceiver() { result.injects(desugar(e.(MethodCall).getReceiver())) }

    /** Gets the block of this call. */
    final ExprCfgNode getBlock() { result.injects(desugar(e.(MethodCall).getBlock())) }
  }

  /** A control-flow node that wraps a `MethodCall` AST expression. */
  class MethodCallCfgNode extends CallCfgNode {
    overlay[global]
    override string getAPrimaryQlClass() { result = "MethodCallCfgNode" }

    MethodCallCfgNode() { super.getExpr() instanceof MethodCall }

    override MethodCall getExpr() { result = super.getExpr() }

    /** Gets the name of this method call. */
    string getMethodName() { result = this.getExpr().getMethodName() }
  }

  /** A control-flow node that wraps a `CaseExpr` AST expression. */
  class CaseExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "CaseExprCfgNode" }

    override CaseExpr e;

    final override CaseExpr getExpr() { result = super.getExpr() }

    /** Gets the expression being compared, if any. */
    final ExprCfgNode getValue() { result.injects(desugar(e.getValue())) }

    /**
     * Gets the `n`th branch of this case expression, either a `when` clause, an `in` clause, or an `else` branch.
     */
    final AstCfgNode getBranch(int n) { result.injects(desugar(e.getBranch(n))) }
  }

  /** A control-flow node that wraps an `InClause` AST expression. */
  class InClauseCfgNode extends AstCfgNode {
    private InClause e;

    InClauseCfgNode() { e = this.getAstNode() }

    override string getAPrimaryQlClass() { result = "InClauseCfgNode" }

    /** Gets the pattern in this `in`-clause. */
    final AstCfgNode getPattern() { result.injects(desugar(e.getPattern())) }

    /** Gets the pattern guard condition in this `in` clause, if any. */
    final ExprCfgNode getCondition() { result.injects(desugar(e.getCondition())) }

    /** Gets the body of this `in`-clause. */
    final ExprCfgNode getBody() { result.injects(desugar(e.getBody())) }
  }

  /** A control-flow node that wraps a `WhenClause` AST expression. */
  class WhenClauseCfgNode extends AstCfgNode {
    private WhenClause e;

    WhenClauseCfgNode() { e = this.getAstNode() }

    override string getAPrimaryQlClass() { result = "WhenClauseCfgNode" }

    /** Gets the body of this `when`-clause. */
    final ExprCfgNode getBody() { result.getAstNode() = desugar(e.getBody()) }

    /** Gets the `i`th pattern this `when`-clause. */
    final ExprCfgNode getPattern(int i) { result.getAstNode() = desugar(e.getPattern(i)) }
  }

  /** A control-flow node that wraps a `CasePattern`. */
  class CasePatternCfgNode extends AstCfgNode {
    CasePattern e;

    CasePatternCfgNode() { e = this.getAstNode() }

    override string getAPrimaryQlClass() { result = "CasePatternCfgNode" }
  }

  /** A control-flow node that wraps an `ArrayPattern` node. */
  class ArrayPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayPatternCfgNode" }

    override ArrayPattern e;

    /** Gets the `n`th element of this list pattern's prefix. */
    final CasePatternCfgNode getPrefixElement(int n) {
      result.injects(desugar(e.getPrefixElement(n)))
    }

    /** Gets the `n`th element of this list pattern's suffix. */
    final CasePatternCfgNode getSuffixElement(int n) {
      result.injects(desugar(e.getSuffixElement(n)))
    }

    /** Gets the variable of the rest token, if any. */
    final VariableWriteAccessCfgNode getRestVariableAccess() {
      result.injects(desugar(e.getRestVariableAccess()))
    }
  }

  /** A control-flow node that wraps a `FindPattern` node. */
  class FindPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "FindPatternCfgNode" }

    override FindPattern e;

    /** Gets the `n`th element of this find pattern. */
    final CasePatternCfgNode getElement(int n) { result.injects(desugar(e.getElement(n))) }

    /** Gets the variable for the prefix of this find pattern, if any. */
    final VariableWriteAccessCfgNode getPrefixVariableAccess() {
      result.injects(desugar(e.getPrefixVariableAccess()))
    }

    /** Gets the variable for the suffix of this find pattern, if any. */
    final VariableWriteAccessCfgNode getSuffixVariableAccess() {
      result.injects(desugar(e.getSuffixVariableAccess()))
    }
  }

  /** A control-flow node that wraps a `HashPattern` node. */
  class HashPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "HashPatternCfgNode" }

    override HashPattern e;

    /** Gets the value of the `n`th pair. */
    final CasePatternCfgNode getValue(int n) { result.injects(desugar(e.getValue(n))) }

    /** Gets the variable of the keyword rest token, if any. */
    final VariableWriteAccessCfgNode getRestVariableAccess() {
      result.injects(desugar(e.getRestVariableAccess()))
    }
  }

  /** A control-flow node that wraps an `AlternativePattern` node. */
  class AlternativePatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "AlternativePatternCfgNode" }

    override AlternativePattern e;

    /** Gets the `n`th alternative. */
    final CasePatternCfgNode getAlternative(int n) { result.injects(desugar(e.getAlternative(n))) }
  }

  /** A control-flow node that wraps an `AsPattern` node. */
  class AsPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "AsPatternCfgNode" }

    override AsPattern e;

    /** Gets the underlying pattern. */
    final CasePatternCfgNode getPattern() { result.injects(desugar(e.getPattern())) }

    /** Gets the variable access for this pattern. */
    final VariableWriteAccessCfgNode getVariableAccess() {
      result.injects(desugar(e.getVariableAccess()))
    }
  }

  /** A control-flow node that wraps a `ParenthesizedPattern` node. */
  class ParenthesizedPatternCfgNode extends CasePatternCfgNode {
    override string getAPrimaryQlClass() { result = "ParenthesizedPatternCfgNode" }

    override ParenthesizedPattern e;

    /** Gets the underlying pattern. */
    final CasePatternCfgNode getPattern() { result.injects(desugar(e.getPattern())) }
  }

  /** A control-flow node that wraps a `ConditionalExpr` AST expression. */
  class ConditionalExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConditionalExprCfgNode" }

    override ConditionalExpr e;

    final override ConditionalExpr getExpr() { result = super.getExpr() }

    /** Gets the condition expression. */
    final ExprCfgNode getCondition() { result.injects(desugar(e.getCondition())) }

    /**
     * Gets the branch of this conditional expression that is taken when the condition
     * evaluates to cond, if any.
     */
    final ExprCfgNode getBranch(boolean cond) { result.injects(desugar(e.getBranch(cond))) }
  }

  /** A control-flow node that wraps a `ConstantAccess` AST expression. */
  class ConstantAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConstantAccessCfgNode" }

    override ConstantAccess e;

    final override ConstantAccess getExpr() { result = super.getExpr() }

    /** Gets the scope expression. */
    final ExprCfgNode getScopeExpr() { result.injects(desugar(e.getScopeExpr())) }
  }

  /** A control-flow node that wraps a `StmtSequence` AST expression. */
  class StmtSequenceCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "StmtSequenceCfgNode" }

    override StmtSequence e;

    final override StmtSequence getExpr() { result = super.getExpr() }

    /** Gets the last statement in this sequence, if any. */
    final ExprCfgNode getLastStmt() { result.injects(desugar(e.getLastStmt())) }
  }

  /** A control-flow node that wraps a `ForExpr` AST expression. */
  class ForExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ForExprCfgNode" }

    override ForExpr e;

    final override ForExpr getExpr() { result = super.getExpr() }

    /** Gets the value being iterated over. */
    final ExprCfgNode getValue() { result.injects(desugar(e.getValue())) }
  }

  /** A control-flow node that wraps a `ParenthesizedExpr` AST expression. */
  class ParenthesizedExprCfgNode extends StmtSequenceCfgNode {
    override string getAPrimaryQlClass() { result = "ParenthesizedExprCfgNode" }

    ParenthesizedExprCfgNode() { this.getExpr() instanceof ParenthesizedExpr }
  }

  /** A control-flow node that wraps a `Pair` AST expression. */
  class PairCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "PairCfgNode" }

    override Pair e;

    final override Pair getExpr() { result = super.getExpr() }

    /**
     * Gets the key expression of this pair.
     */
    final ExprCfgNode getKey() { result.injects(desugar(e.getKey())) }

    /**
     * Gets the value expression of this pair.
     */
    final ExprCfgNode getValue() { result.injects(desugar(e.getValue())) }
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

  /** A control-flow node that wraps an `InstanceVariableAccess` AST expression. */
  class InstanceVariableAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "InstanceVariableAccessCfgNode" }

    override InstanceVariableAccess e;

    override InstanceVariableAccess getExpr() { result = super.getExpr() }

    /**
     * Gets the synthetic receiver (`self`) of this instance variable access.
     */
    final CfgNode getReceiver() { result.injects(desugar(e.getReceiver())) }
  }

  /** A control-flow node that wraps a `SelfVariableAccess` AST expression. */
  class SelfVariableAccessCfgNode extends VariableAccessCfgNode {
    final override string getAPrimaryQlClass() { result = "SelfVariableAccessCfgNode" }

    override SelfVariableAccess e;

    override SelfVariableAccess getExpr() { result = super.getExpr() }
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

    override VariableWriteAccess e;

    override VariableWriteAccess getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `LocalVariableWriteAccess` AST expression. */
  class LocalVariableWriteAccessCfgNode extends VariableWriteAccessCfgNode {
    override string getAPrimaryQlClass() { result = "LocalVariableWriteAccessCfgNode" }

    override LocalVariableWriteAccess e;

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

    overlay[global]
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

    overlay[global]
    final override ConstantValue getConstantValue() {
      result = StmtSequenceCfgNode.super.getConstantValue()
    }
  }

  /** A control-flow node that wraps a `StringlikeLiteral` AST expression. */
  class StringlikeLiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "StringlikeLiteralCfgNode" }

    override StringlikeLiteral e;

    override StringlikeLiteral getExpr() { result = super.getExpr() }

    /** Gets the `n`th component of this `StringlikeLiteral` */
    StringComponentCfgNode getComponent(int n) { result.injects(desugar(e.getComponent(n))) }

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

  /** A control-flow node that wraps a `SplatExpr` AST expression. */
  class SplatExprCfgNode extends UnaryOperationCfgNode {
    override string getAPrimaryQlClass() { result = "SplatExprCfgNode" }

    override SplatExpr e;

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
  overlay[global]
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
  overlay[global]
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
