/**
 * Provides classes representing the control flow graph within callables.
 */
overlay[local?]
module;

private import unified
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType
private import ControlFlowGraphPlugin

private module Cfg0 = Make0<Location, Ast>;

private module Cfg1 = Make1<Input>;

private module Cfg2 = Make2<Input>;

private import Cfg0
private import Cfg1
import Cfg2

/** Provides an implementation of the AST signature for Unified. */
module Ast implements AstSig<Location> {
  private import unified as U

  class AstNode = U::AstNode;

  private predicate skipControlFlow(AstNode e) {
    e instanceof Modifier
    or
    e instanceof Identifier and not e instanceof IdentifierExpr
    or
    e instanceof Operator
    or
    not e.fromSource()
  }

  private AstNode adjustedGetChild(AstNode n, int index) { deferScope(n, index, result) }

  AstNode getChild(AstNode n, int index) {
    result.getParent() = n and
    result.getParentIndex() = index and
    not n instanceof Callable and
    not skipControlFlow(n) and
    not skipControlFlow(result) and
    not adjustedGetChild(_, _) = result
    or
    adjustedGetChild(n, index) = result
    or
    n.(FunctionExpr).getCaptureDeclaration(index) = result
    or
    n.(FunctionDeclaration).getNameNode() = result and index = 0
  }

  Callable getEnclosingCallable(AstNode node) { result = node.getEnclosingCallable() }

  class Callable extends U::Callable {
    Callable() { this.fromSource() }
  }

  AstNode callableGetBody(Callable c) { result = c.getBody() }

  class Parameter extends U::Parameter {
    Expr getDefaultValue() { result = super.getDefault() }

    AstNode getPattern() {
      result = super.getPattern()
      or
      not exists(super.getPattern()) and result = this
    }
  }

  Parameter callableGetParameter(Callable c, int index) {
    result = c.(AccessorDeclaration).getParameter(index) or
    result = c.(ConstructorDeclaration).getParameter(index) or
    result = c.(FunctionDeclaration).getParameter(index) or
    result = c.(FunctionExpr).getParameter(index)
  }

  class Stmt = U::Stmt;

  class Expr = U::Expr;

  /**
   * Holds if `s` is the `n`th statement in the constructed `try` block of
   * `defer`.
   *
   * For example, the following `defer` statements
   * ```
   * {
   *   s1
   *   defer { s5 }
   *   s2
   *   defer { s4 }
   *   s3
   * }
   * ```
   * are transformed into these `try`-`finally` blocks:
   * ```
   * {
   *   s1
   *   try {
   *     s2
   *     try {
   *       s3
   *     } finally {
   *       s4
   *     }
   *   } finally {
   *     s5
   *   }
   * }
   * ```
   */
  private predicate deferScope(U::DeferStmt defer, int n, Stmt s) {
    exists(U::Block block, int deferIdx | block.getStmt(deferIdx) = defer |
      block.getStmt(deferIdx + 1) = s and n = 0
      or
      exists(Stmt mid |
        deferScope(defer, n - 1, mid) and
        not mid instanceof U::DeferStmt and
        block.getStmt(deferIdx + 1 + n) = s
      )
    )
  }

  class BlockStmt extends Stmt instanceof U::Block {
    Stmt getStmt(int n) { result = super.getStmt(n) and not deferScope(_, _, result) }

    Stmt getLastStmt() {
      exists(int i | result = this.getStmt(i) and not exists(this.getStmt(i + 1)))
    }
  }

  class ExprStmt extends Stmt {
    ExprStmt() { none() }

    Expr getExpr() { none() }
  }

  class IfStmt extends Stmt instanceof U::GuardIfStmt {
    Expr getCondition() { result = super.getCondition() }

    Stmt getThen() { none() }

    Stmt getElse() { result = super.getElse() }
  }

  abstract class LoopStmt extends Stmt {
    Stmt getBody() { none() }
  }

  class WhileStmt extends LoopStmt instanceof U::WhileStmt {
    override Stmt getBody() { result = U::WhileStmt.super.getBody() }

    Expr getCondition() { result = super.getCondition() }
  }

  class DoStmt extends LoopStmt instanceof U::DoWhileStmt {
    override Stmt getBody() { result = U::DoWhileStmt.super.getBody() }

    Expr getCondition() { result = super.getCondition() }
  }

  class UntilStmt extends LoopStmt {
    UntilStmt() { none() }

    Expr getCondition() { none() }
  }

  class ForStmt extends LoopStmt {
    ForStmt() { none() }

    AstNode getInit(int index) { none() }

    Expr getCondition() { none() }

    AstNode getUpdate(int index) { none() }
  }

  class ForEachStmt extends LoopStmt instanceof U::ForEachStmt {
    override Stmt getBody() { result = U::ForEachStmt.super.getBody() }

    Expr getVariable() { result = super.getPattern() }

    Expr getCollection() { result = super.getIterable() }
  }

  AstNode getLoopGuard(ForEachStmt foreachstmt) { result = foreachstmt.(U::ForEachStmt).getGuard() }

  class BreakStmt = U::BreakExpr;

  class ContinueStmt = U::ContinueExpr;

  class LabeledStmt = U::LabeledStmt;

  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  class ReturnStmt extends U::ReturnExpr {
    Expr getExpr() { result = super.getValue() }
  }

  class Throw extends U::ThrowExpr {
    Expr getExpr() { result = super.getValue() }
  }

  class TryStmt extends Stmt {
    TryStmt() { this instanceof U::TryExpr or this instanceof U::DeferStmt }

    AstNode getBody(int index) {
      index = 0 and result = this.(U::TryExpr).getBody()
      or
      deferScope(this, index, result)
    }

    CatchClause getCatch(int index) { result = this.(U::TryExpr).getCatchClause(index) }

    Stmt getFinally() { result = this.(U::DeferStmt).getBody() }
  }

  class CatchClause extends U::CatchClause {
    AstNode getPattern() { result = super.getPattern() }

    AstNode getVariable() { none() }

    Expr getCondition() { none() }

    Stmt getBody() { result = super.getBody() }
  }

  class Switch extends U::SwitchExpr {
    Expr getExpr() { result = super.getValue() }

    Case getCase(int index) { result = super.getCase(index) }

    Stmt getStmt(int index) { none() }
  }

  class Case extends U::SwitchCase {
    AstNode getPattern(int index) { result = super.getPattern() and index = 0 }

    Expr getGuard() { none() }

    AstNode getBody() { result = super.getBody() }
  }

  class DefaultCase extends Case {
    DefaultCase() { not exists(super.getPattern()) }
  }

  class ConditionalExpr = U::IfExpr;

  // TODO: sort out the relationship between BinaryExpr and Assignment
  class BinaryExpr extends U::BinaryExpr {
    Expr getLeftOperand() { result = super.getLeft() }

    Expr getRightOperand() { result = super.getRight() }
  }

  class LogicalAndExpr extends BinaryExpr, U::LogicalAndExpr { }

  class LogicalOrExpr extends BinaryExpr, U::LogicalOrExpr { }

  class NullCoalescingExpr extends BinaryExpr, U::NullCoalescingExpr { }

  class UnaryExpr = U::UnaryExpr;

  class LogicalNotExpr = U::LogicalNotExpr;

  class Assignment extends BinaryExpr, U::Assignment { }

  class AssignExpr extends Assignment, U::AssignExpr { }

  class CompoundAssignment extends Assignment, U::CompoundAssignExpr { }

  class AssignLogicalAndExpr extends CompoundAssignment {
    AssignLogicalAndExpr() { this.getOperator().getValue() = "&&=" }
  }

  class AssignLogicalOrExpr extends CompoundAssignment {
    AssignLogicalOrExpr() { this.getOperator().getValue() = "||=" }
  }

  class AssignNullCoalescingExpr extends CompoundAssignment {
    AssignNullCoalescingExpr() { this.getOperator().getValue() = "??=" }
  }

  class BooleanLiteral extends U::BooleanLiteral {
    boolean getValue() { result.toString() = super.getValue() }
  }

  class PatternMatchExpr extends U::PatternGuardExpr {
    Expr getExpr() { result = super.getValue() }

    AstNode getPattern() { result = super.getPattern() }
  }
}

private predicate mayThrow(AstNode ast) { any(ControlFlowGraphPlugin p).mayThrow(ast) }

private module Input implements InputSig1, InputSig2 {
  private import codeql.util.Void

  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  class Label extends string {
    Label() {
      any(LabeledStmt l).getLabelName() = this or
      any(BreakExpr b).getLabelName() = this or
      any(ContinueExpr c).getLabelName() = this
    }

    string toString() { result = this }
  }

  predicate hasLabel(Ast::AstNode n, Label l) {
    l = n.(LabeledStmt).getLabelName()
    or
    l = n.(BreakExpr).getLabelName()
    or
    l = n.(ContinueExpr).getLabelName()
  }

  class CallableContext = Void;

  predicate beginAbruptCompletion(
    AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    mayThrow(ast) and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = false
  }

  predicate endAbruptCompletion(AstNode ast, PreControlFlowNode n, AbruptCompletion c) { none() }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) { none() }
}
