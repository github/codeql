/** Provides classes representing nodes in a control flow graph. */

private import codeql.ruby.AST
private import codeql.ruby.controlflow.BasicBlocks
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.internal.Constant
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
 * Each AST node maps to zero or more `AstCfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class AstCfgNode extends CfgNode, TElementNode {
  private Splits splits;
  AstNode e;

  AstCfgNode() { this = TElementNode(_, e, splits) }

  final override AstNode getNode() { result = e }

  override Location getLocation() { result = e.getLocation() }

  final override string toString() {
    exists(string s | s = e.toString() |
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
  override Expr e;

  ExprCfgNode() { e = this.getNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }

  private ExprCfgNode getSource() {
    exists(Ssa::WriteDefinition def |
      def.assigns(result) and
      this = def.getARead()
    )
  }

  /**
   * DEPRECATED: Use `getConstantValue` instead.
   *
   * Gets the textual (constant) value of this expression, if any.
   */
  deprecated string getValueText() { result = this.getConstantValue().toString() }

  /** Gets the constant value of this expression, if any. */
  cached
  ConstantValue getConstantValue() { result = this.getSource().getConstantValue() }
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

/** A control-flow node that wraps a `StringComponent` AST expression. */
class StringComponentCfgNode extends AstCfgNode {
  StringComponentCfgNode() { this.getNode() instanceof StringComponent }

  /** Gets the constant value of this string component. */
  ConstantValue getConstantValue() { result = this.getNode().(StringComponent).getConstantValue() }
}

/** A control-flow node that wraps a `RegExpComponent` AST expression. */
class RegExpComponentCfgNode extends AstCfgNode {
  RegExpComponentCfgNode() { this.getNode() instanceof RegExpComponent }

  /** Gets the constant value of this regex component. */
  ConstantValue getConstantValue() { result = this.getNode().(RegExpComponent).getConstantValue() }
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
    cfnChild.getNode() = desugar(child)
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
      not mid.getANode().getNode() = child
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
    cfn.getNode() = this and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getASuccessor() and
      not mid.getANode().getNode() = child
    )
  }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  private class LiteralChildMapping extends ExprChildMapping, Literal {
    override predicate relevantChild(AstNode n) { none() }
  }

  /** A control-flow node that wraps an `ArrayLiteral` AST expression. */
  class LiteralCfgNode extends ExprCfgNode {
    override LiteralChildMapping e;

    override Literal getExpr() { result = super.getExpr() }

    override ConstantValue getConstantValue() { result = e.getConstantValue() }
  }

  private class AssignExprChildMapping extends ExprChildMapping, AssignExpr {
    override predicate relevantChild(AstNode n) { n = this.getAnOperand() }
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
    override predicate relevantChild(AstNode n) { n = this.getAnOperand() }
  }

  /** A control-flow node that wraps an `Operation` AST expression. */
  class OperationCfgNode extends ExprCfgNode {
    override OperationExprChildMapping e;

    override Operation getExpr() { result = super.getExpr() }

    /** Gets an operand of this operation. */
    final ExprCfgNode getAnOperand() { e.hasCfgChild(e.getAnOperand(), this, result) }
  }

  private predicate unaryConstFold(UnaryOperationCfgNode unop, string op, ConstantValue value) {
    value = unop.getOperand().getConstantValue() and
    op = unop.getExpr().getOperator()
  }

  private class RequiredUnaryConstantValue extends RequiredConstantValue {
    override predicate requiredInt(int i) {
      exists(ConstantValue value |
        unaryConstFold(_, "-", value) and
        i = -value.getInt()
      )
    }

    override predicate requiredFloat(float f) {
      exists(ConstantValue value |
        unaryConstFold(_, "-", value) and
        f = -value.getFloat()
      )
    }
  }

  /** A control-flow node that wraps a `UnaryOperation` AST expression. */
  class UnaryOperationCfgNode extends OperationCfgNode {
    private UnaryOperation uo;

    UnaryOperationCfgNode() { e = uo }

    override UnaryOperation getExpr() { result = super.getExpr() }

    /** Gets the operand of this unary operation. */
    final ExprCfgNode getOperand() { e.hasCfgChild(uo.getOperand(), this, result) }

    final override ConstantValue getConstantValue() {
      // TODO: Implement support for complex numbers and rational numbers
      exists(string op, ConstantValue value | unaryConstFold(this, op, value) |
        op = "+" and
        result = value
        or
        op = "-" and
        (
          result.isInt(-value.getInt())
          or
          result.isFloat(-value.getFloat())
        )
      )
    }
  }

  private predicate binaryConstFold(
    BinaryOperationCfgNode binop, string op, ConstantValue left, ConstantValue right
  ) {
    left = binop.getLeftOperand().getConstantValue() and
    right = binop.getRightOperand().getConstantValue() and
    op = binop.getExpr().getOperator()
  }

  private class RequiredBinaryConstantValue extends RequiredConstantValue {
    override predicate requiredInt(int i) {
      exists(string op, ConstantValue left, ConstantValue right |
        binaryConstFold(_, op, left, right)
      |
        op = "+" and
        i = left.getInt() + right.getInt()
        or
        op = "-" and
        i = left.getInt() - right.getInt()
        or
        op = "*" and
        i = left.getInt() * right.getInt()
        or
        op = "/" and
        i = left.getInt() / right.getInt()
      )
    }

    override predicate requiredFloat(float f) {
      exists(string op, ConstantValue left, ConstantValue right |
        binaryConstFold(_, op, left, right)
      |
        op = "+" and
        f =
          [
            left.getFloat() + right.getFloat(), left.getInt() + right.getFloat(),
            left.getFloat() + right.getInt()
          ]
        or
        op = "-" and
        f =
          [
            left.getFloat() - right.getFloat(), left.getInt() - right.getFloat(),
            left.getFloat() - right.getInt()
          ]
        or
        op = "*" and
        f =
          [
            left.getFloat() * right.getFloat(), left.getInt() * right.getFloat(),
            left.getFloat() * right.getInt()
          ]
        or
        op = "/" and
        f =
          [
            left.getFloat() / right.getFloat(), left.getInt() / right.getFloat(),
            left.getFloat() / right.getInt()
          ]
      )
    }

    override predicate requiredString(string s) {
      exists(string op, ConstantValue left, ConstantValue right |
        binaryConstFold(_, op, left, right)
      |
        op = "+" and
        s = left.getString() + right.getString() and
        s.length() <= 10000
      )
    }
  }

  /** A control-flow node that wraps a `BinaryOperation` AST expression. */
  class BinaryOperationCfgNode extends OperationCfgNode {
    private BinaryOperation bo;

    BinaryOperationCfgNode() { e = bo }

    override BinaryOperation getExpr() { result = super.getExpr() }

    /** Gets the left operand of this binary operation. */
    final ExprCfgNode getLeftOperand() { e.hasCfgChild(bo.getLeftOperand(), this, result) }

    /** Gets the right operand of this binary operation. */
    final ExprCfgNode getRightOperand() { e.hasCfgChild(bo.getRightOperand(), this, result) }

    final override ConstantValue getConstantValue() {
      // TODO: Implement support for complex numbers and rational numbers
      exists(string op, ConstantValue left, ConstantValue right |
        binaryConstFold(this, op, left, right)
      |
        op = "+" and
        (
          result.isInt(left.getInt() + right.getInt())
          or
          result
              .isFloat([
                  left.getFloat() + right.getFloat(), left.getInt() + right.getFloat(),
                  left.getFloat() + right.getInt()
                ])
          or
          result.isString(left.getString() + right.getString())
        )
        or
        op = "-" and
        (
          result.isInt(left.getInt() - right.getInt())
          or
          result
              .isFloat([
                  left.getFloat() - right.getFloat(), left.getInt() - right.getFloat(),
                  left.getFloat() - right.getInt()
                ])
        )
        or
        op = "*" and
        (
          result.isInt(left.getInt() * right.getInt())
          or
          result
              .isFloat([
                  left.getFloat() * right.getFloat(), left.getInt() * right.getFloat(),
                  left.getFloat() * right.getInt()
                ])
        )
        or
        op = "/" and
        (
          result.isInt(left.getInt() / right.getInt())
          or
          result
              .isFloat([
                  left.getFloat() / right.getFloat(), left.getInt() / right.getFloat(),
                  left.getFloat() / right.getInt()
                ])
        )
      )
    }
  }

  private class BlockArgumentChildMapping extends ExprChildMapping, BlockArgument {
    override predicate relevantChild(AstNode n) { n = this.getValue() }
  }

  /** A control-flow node that wraps a `BlockArgument` AST expression. */
  class BlockArgumentCfgNode extends ExprCfgNode {
    override BlockArgumentChildMapping e;

    final override BlockArgument getExpr() { result = ExprCfgNode.super.getExpr() }

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
    override CallExprChildMapping e;

    override Call getExpr() { result = super.getExpr() }

    /** Gets the `n`th argument of this call. */
    final ExprCfgNode getArgument(int n) { e.hasCfgChild(e.getArgument(n), this, result) }

    /** Gets the the keyword argument whose key is `keyword` of this call. */
    final ExprCfgNode getKeywordArgument(string keyword) {
      exists(PairCfgNode n |
        e.hasCfgChild(e.getAnArgument(), this, n) and
        n.getKey().getExpr().getConstantValue().isSymbol(keyword) and
        result = n.getValue()
      )
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
    MethodCallCfgNode() { super.getExpr() instanceof MethodCall }

    override MethodCall getExpr() { result = super.getExpr() }
  }

  private class CaseExprChildMapping extends ExprChildMapping, CaseExpr {
    override predicate relevantChild(AstNode e) { e = this.getValue() or e = this.getABranch() }
  }

  /** A control-flow node that wraps a `CaseExpr` AST expression. */
  class CaseExprCfgNode extends ExprCfgNode {
    override CaseExprChildMapping e;

    final override CaseExpr getExpr() { result = ExprCfgNode.super.getExpr() }

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
    override InClauseChildMapping e;

    /** Gets the pattern in this `in`-clause. */
    final AstCfgNode getPattern() { e.hasCfgChild(e.getPattern(), this, result) }

    /** Gets the pattern guard condition in this `in` clause, if any. */
    final ExprCfgNode getCondition() { e.hasCfgChild(e.getCondition(), this, result) }

    /** Gets the body of this `in`-clause. */
    final ExprCfgNode getBody() { e.hasCfgChild(e.getBody(), this, result) }
  }

  private class WhenClauseChildMapping extends NonExprChildMapping, WhenClause {
    override predicate relevantChild(AstNode e) { e = this.getBody() }
  }

  /** A control-flow node that wraps a `WhenClause` AST expression. */
  class WhenClauseCfgNode extends AstCfgNode {
    override WhenClauseChildMapping e;

    /** Gets the body of this `when`-clause. */
    final ExprCfgNode getBody() { e.hasCfgChild(e.getBody(), this, result) }
  }

  /** A control-flow node that wraps a `CasePattern`. */
  class CasePatternCfgNode extends AstCfgNode {
    override CasePattern e;
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
    override ParenthesizedPatternChildMapping e;

    /** Gets the underlying pattern. */
    final CasePatternCfgNode getPattern() { e.hasCfgChild(e.getPattern(), this, result) }
  }

  private class ConditionalExprChildMapping extends ExprChildMapping, ConditionalExpr {
    override predicate relevantChild(AstNode n) { n = [this.getCondition(), this.getBranch(_)] }
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
    override predicate relevantChild(AstNode n) { n = this.getScopeExpr() }
  }

  /** A control-flow node that wraps a `ConditionalExpr` AST expression. */
  class ConstantAccessCfgNode extends ExprCfgNode {
    override ConstantAccessChildMapping e;

    final override ConstantAccess getExpr() { result = super.getExpr() }

    /** Gets the scope expression. */
    final ExprCfgNode getScopeExpr() { e.hasCfgChild(e.getScopeExpr(), this, result) }

    override ConstantValue getConstantValue() { result = this.getExpr().getConstantValue() }
  }

  private class StmtSequenceChildMapping extends ExprChildMapping, StmtSequence {
    override predicate relevantChild(AstNode n) { n = this.getLastStmt() }
  }

  /** A control-flow node that wraps a `StmtSequence` AST expression. */
  class StmtSequenceCfgNode extends ExprCfgNode {
    override StmtSequenceChildMapping e;

    final override StmtSequence getExpr() { result = ExprCfgNode.super.getExpr() }

    /** Gets the last statement in this sequence, if any. */
    final ExprCfgNode getLastStmt() { e.hasCfgChild(e.getLastStmt(), this, result) }
  }

  private class ForExprChildMapping extends ExprChildMapping, ForExpr {
    override predicate relevantChild(AstNode n) { n = this.getValue() }
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

  private class PairChildMapping extends ExprChildMapping, Pair {
    override predicate relevantChild(AstNode n) { n = [this.getKey(), this.getValue()] }
  }

  /** A control-flow node that wraps a `Pair` AST expression. */
  class PairCfgNode extends ExprCfgNode {
    override PairChildMapping e;

    final override Pair getExpr() { result = ExprCfgNode.super.getExpr() }

    /**
     * Gets the key expression of this pair.
     */
    final ExprCfgNode getKey() { e.hasCfgChild(e.getKey(), this, result) }

    /**
     * Gets the value expression of this pair.
     */
    final ExprCfgNode getValue() { e.hasCfgChild(e.getValue(), this, result) }
  }

  /** A control-flow node that wraps a `VariableReadAccess` AST expression. */
  class VariableReadAccessCfgNode extends ExprCfgNode {
    override VariableReadAccess e;

    final override VariableReadAccess getExpr() { result = ExprCfgNode.super.getExpr() }
  }

  /** A control-flow node that wraps a `VariableWriteAccess` AST expression. */
  class VariableWriteAccessCfgNode extends ExprCfgNode {
    override VariableWriteAccess e;

    final override VariableWriteAccess getExpr() { result = ExprCfgNode.super.getExpr() }
  }

  /** A control-flow node that wraps a `InstanceVariableWriteAccess` AST expression. */
  class InstanceVariableWriteAccessCfgNode extends ExprCfgNode {
    override InstanceVariableWriteAccess e;

    final override InstanceVariableWriteAccess getExpr() { result = ExprCfgNode.super.getExpr() }
  }

  /** A control-flow node that wraps a `StringInterpolationComponent` AST expression. */
  class StringInterpolationComponentCfgNode extends StringComponentCfgNode, StmtSequenceCfgNode {
    StringInterpolationComponentCfgNode() { this.getNode() instanceof StringInterpolationComponent }

    // If last statement in the interpolation is a constant or local variable read,
    // we attempt to look up its string value.
    // If there's a result, we return that as the string value of the interpolation.
    final override ConstantValue getConstantValue() {
      result = this.getLastStmt().getConstantValue()
    }
  }

  /** A control-flow node that wraps a `RegExpInterpolationComponent` AST expression. */
  class RegExpInterpolationComponentCfgNode extends RegExpComponentCfgNode, StmtSequenceCfgNode {
    RegExpInterpolationComponentCfgNode() { this.getNode() instanceof RegExpInterpolationComponent }

    // If last statement in the interpolation is a constant or local variable read,
    // attempt to look up its definition and return the definition's `getConstantValue()`.
    final override ConstantValue getConstantValue() {
      result = this.getLastStmt().getConstantValue()
    }
  }

  private class StringlikeLiteralChildMapping extends ExprChildMapping, StringlikeLiteral {
    override predicate relevantChild(AstNode n) { n = this.getComponent(_) }
  }

  pragma[nomagic]
  private string getStringComponentCfgNodeValue(StringComponentCfgNode c) {
    result = c.getConstantValue().toString()
  }

  // 0 components results in the empty string
  // if all interpolations have a known string value, we will get a result
  language[monotonicAggregates]
  private string getStringlikeLiteralCfgNodeValue(StringlikeLiteralCfgNode n) {
    result =
      concat(StringComponentCfgNode c, int i |
        c = n.getComponent(i)
      |
        getStringComponentCfgNodeValue(c) order by i
      )
  }

  private class RequiredStringlikeLiteralConstantValue extends RequiredConstantValue {
    override predicate requiredString(string s) {
      exists(StringlikeLiteralCfgNode n |
        s = getStringlikeLiteralCfgNodeValue(n) and
        not n.getExpr() instanceof SymbolLiteral
      )
    }

    override predicate requiredSymbol(string s) {
      exists(StringlikeLiteralCfgNode n |
        s = getStringlikeLiteralCfgNodeValue(n) and
        n.getExpr() instanceof SymbolLiteral
      )
    }
  }

  /** A control-flow node that wraps a `StringlikeLiteral` AST expression. */
  class StringlikeLiteralCfgNode extends ExprCfgNode {
    override StringlikeLiteralChildMapping e;

    final override StringlikeLiteral getExpr() { result = super.getExpr() }

    /** Gets the `n`th component of this `StringlikeLiteral` */
    StringComponentCfgNode getComponent(int n) { e.hasCfgChild(e.getComponent(n), this, result) }

    /** Gets a component of this `StringlikeLiteral` */
    StringComponentCfgNode getAComponent() { result = this.getComponent(_) }

    final override ConstantValue getConstantValue() {
      if this.getExpr() instanceof SymbolLiteral
      then result.isSymbol(getStringlikeLiteralCfgNodeValue(this))
      else result.isString(getStringlikeLiteralCfgNodeValue(this))
    }
  }

  /** A control-flow node that wraps a `StringLiteral` AST expression. */
  class StringLiteralCfgNode extends ExprCfgNode {
    override StringLiteral e;

    final override StringLiteral getExpr() { result = super.getExpr() }
  }

  private class RegExpLiteralChildMapping extends ExprChildMapping, RegExpLiteral {
    override predicate relevantChild(AstNode n) { n = this.getComponent(_) }
  }

  pragma[nomagic]
  private string getRegExpComponentCfgNodeValue(RegExpComponentCfgNode c) {
    result = c.getConstantValue().toString()
  }

  language[monotonicAggregates]
  private string getRegExpLiteralCfgNodeValue(RegExpLiteralCfgNode n) {
    result =
      concat(RegExpComponentCfgNode c, int i |
        c = n.getComponent(i)
      |
        getRegExpComponentCfgNodeValue(c) order by i
      )
  }

  private class RequiredRexExpLiteralConstantValue extends RequiredConstantValue {
    override predicate requiredString(string s) { s = getRegExpLiteralCfgNodeValue(_) }
  }

  /** A control-flow node that wraps a `RegExpLiteral` AST expression. */
  class RegExpLiteralCfgNode extends ExprCfgNode {
    override RegExpLiteralChildMapping e;

    RegExpComponentCfgNode getComponent(int n) { e.hasCfgChild(e.getComponent(n), this, result) }

    final override RegExpLiteral getExpr() { result = super.getExpr() }

    final override ConstantValue::ConstantStringValue getConstantValue() {
      result.isString(getRegExpLiteralCfgNodeValue(this))
    }
  }

  /** A control-flow node that wraps a `ComparisonOperation` AST expression. */
  class ComparisonOperationCfgNode extends BinaryOperationCfgNode {
    ComparisonOperationCfgNode() { e instanceof ComparisonOperation }

    override ComparisonOperation getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps a `RelationalOperation` AST expression. */
  class RelationalOperationCfgNode extends ComparisonOperationCfgNode {
    RelationalOperationCfgNode() { e instanceof RelationalOperation }

    final override RelationalOperation getExpr() { result = super.getExpr() }
  }

  /** A control-flow node that wraps an `ElementReference` AST expression. */
  class ElementReferenceCfgNode extends MethodCallCfgNode {
    ElementReferenceCfgNode() { e instanceof ElementReference }

    final override ElementReference getExpr() { result = super.getExpr() }
  }
}
