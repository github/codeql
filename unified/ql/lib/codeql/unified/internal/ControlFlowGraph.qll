/**
 * Provides classes representing the control flow graph within callables.
 */
overlay[local?]
module;

private import unified
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType

private module Cfg0 = Make0<Location, Ast>;

private module Cfg1 = Make1<Input>;

private module Cfg2 = Make2<Input>;

private import Cfg0
private import Cfg1
private import Cfg2
import Public

/** Provides an implementation of the AST signature for Unified. */
private module Ast implements AstSig<Location> {
  private import unified as U

  class AstNode = U::AstNode;

  private predicate skipControlFlow(AstNode e) { e instanceof Modifier or e instanceof Identifier }

  AstNode getChild(AstNode n, int index) {
    result.getParent() = n and
    result.getParentIndex() = index and
    not n instanceof Callable and
    not skipControlFlow(n) and
    not skipControlFlow(result)
  }

  Callable getEnclosingCallable(AstNode node) {
    exists(AstNode parent | parent = node.getParent() |
      result = parent
      or
      not parent instanceof Callable and
      result = getEnclosingCallable(parent)
    )
  }

  class Callable = U::Callable;

  AstNode callableGetBody(Callable c) {
    result = c.(AccessorDeclaration).getBody() or
    result = c.(ConstructorDeclaration).getBody() or
    result = c.(DestructorDeclaration).getBody() or
    result = c.(FunctionDeclaration).getBody() or
    result = c.(FunctionExpr).getBody() or
    result = c.(InitializerDeclaration).getBody() or
    result = c.(TopLevel).getBody()
  }

  class Parameter extends U::Parameter {
    Expr getDefaultValue() { result = super.getDefault() }

    AstNode getPattern() { result = super.getPattern() }
  }

  Parameter callableGetParameter(Callable c, int index) {
    result = c.(AccessorDeclaration).getParameter(index) or
    result = c.(ConstructorDeclaration).getParameter(index) or
    result = c.(FunctionDeclaration).getParameter(index) or
    result = c.(FunctionExpr).getParameter(index)
  }

  class Stmt = U::Stmt;

  class Expr = U::Expr;

  class BlockStmt = U::Block;

  class ExprStmt extends Stmt {
    ExprStmt() { none() }

    Expr getExpr() { none() }
  }

  class IfStmt extends Stmt {
    IfStmt() { none() }

    Expr getCondition() { none() }

    Stmt getThen() { none() }

    Stmt getElse() { none() }
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

  class ForeachStmt extends LoopStmt instanceof U::ForEachStmt {
    override Stmt getBody() { result = U::ForEachStmt.super.getBody() }

    // TODO support foreach guard
    //
    // TODO: Expr != Pattern
    Expr getVariable() { result = super.getPattern() }

    Expr getCollection() { result = super.getIterable() }
  }

  class BreakStmt = U::BreakExpr;

  class ContinueStmt = U::ContinueExpr;

  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  class ReturnStmt extends U::ReturnExpr {
    Expr getExpr() { result = super.getValue() }
  }

  class Throw extends U::ThrowExpr {
    Expr getExpr() { result = super.getValue() }
  }

  class TryStmt extends U::TryExpr {
    AstNode getBody(int index) { index = 0 and result = super.getBody() }

    CatchClause getCatch(int index) { result = super.getCatchClause(index) }

    Stmt getFinally() { none() }
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

  // TODO
  class Assignment extends BinaryExpr {
    Assignment() { none() }
  }

  class AssignExpr extends Assignment { }

  class CompoundAssignment extends Assignment { }

  class AssignLogicalAndExpr extends CompoundAssignment { }

  class AssignLogicalOrExpr extends CompoundAssignment { }

  class AssignNullCoalescingExpr extends CompoundAssignment { }

  class BooleanLiteral extends U::BooleanLiteral {
    boolean getValue() { result.toString() = super.getValue() }
  }

  class PatternMatchExpr extends U::PatternGuardExpr {
    Expr getExpr() { result = super.getValue() }

    AstNode getPattern() { result = super.getPattern() }
  }
}

private module Input implements InputSig1, InputSig2 {
  private import codeql.util.Void

  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  class Label extends string {
    Label() {
      any(LabeledStmt l).getLabel().getValue() = this or
      any(BreakExpr b).getLabel().getValue() = this or
      any(ContinueExpr c).getLabel().getValue() = this
    }

    string toString() { result = this }
  }

  private Label getLabelOfStmt(Stmt s) {
    exists(LabeledStmt l | s = l.getStmt() |
      result = l.getLabel().getValue() or
      result = getLabelOfStmt(l)
    )
  }

  predicate hasLabel(Ast::AstNode n, Label l) {
    l = getLabelOfStmt(n)
    or
    l = n.(BreakExpr).getLabel().getValue()
    or
    l = n.(ContinueExpr).getLabel().getValue()
  }

  class CallableContext = Void;

  predicate beginAbruptCompletion(
    AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    none()
  }

  predicate endAbruptCompletion(AstNode ast, PreControlFlowNode n, AbruptCompletion c) { none() }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) { none() }
}
