private import codeql.actions.Ast
private import codeql.controlflow.ControlFlowGraph as CfgShared
private import codeql.Locations
private import codeql.util.Void

private class ActionsAstNode = AstNode;

module CfgImpl {
  private predicate isDeclaredEnvExpr(AstNode parent, AstNode child) {
    exists(Workflow workflow | parent = workflow and child = workflow.getEnv().getAnEnvVarExpr())
    or
    exists(Job job | parent = job and child = job.getEnv().getAnEnvVarExpr())
    or
    exists(Step step | parent = step and child = step.getEnv().getAnEnvVarExpr())
  }

  private predicate isCfgChild(AstNode parent, AstNode child) {
    isDeclaredEnvExpr(parent, child)
    or
    exists(CompositeAction action |
      parent = action and
      (child = action.getAnInput() or child = action.getOutputs() or child = action.getRuns())
    )
    or
    exists(ReusableWorkflow workflow |
      parent = workflow and
      (
        child = workflow.getAnInput() or
        child = workflow.getOutputs() or
        child = workflow.getStrategy() or
        child = workflow.getAJob()
      )
    )
    or
    exists(Workflow workflow |
      parent = workflow and
      not workflow instanceof ReusableWorkflow and
      (child = workflow.getStrategy() or child = workflow.getAJob())
    )
    or
    exists(Runs runs | parent = runs and child = runs.getStep(_))
    or
    exists(Outputs outputs | parent = outputs and child = outputs.getAnOutputExpr())
    or
    exists(Strategy strategy | parent = strategy and child = strategy.getAMatrixVarExpr())
    or
    exists(LocalJob job |
      parent = job and
      (child = job.getAStep() or child = job.getOutputs() or child = job.getStrategy())
    )
    or
    exists(ExternalJob job |
      parent = job and
      (
        child = job.getArgumentExpr(_) or
        child = job.getOutputs() or
        child = job.getStrategy()
      )
    )
    or
    exists(UsesStep uses | parent = uses and child = uses.getArgumentExpr(_))
    or
    exists(Run run |
      parent = run and
      (child = run.getAnScriptExpr() or child = run.getScript())
    )
  }

  private AstNode getCfgChild(AstNode parent, int index) {
    result =
      rank[index](AstNode child, Location l |
        isCfgChild(parent, child) and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }

  private module CfgAst implements CfgShared::AstSig<Location> {
    class AstNode = ActionsAstNode;

    AstNode getChild(AstNode node, int index) { result = getCfgChild(node, index) }

    class Callable extends AstNode {
      Callable() {
        this instanceof CompositeAction
        or
        this instanceof Workflow and
        not exists(CompositeAction action | action.getLocation() = this.getLocation())
      }
    }

    AstNode callableGetBody(Callable callable) { result = callable }

    /**
     * Gets the unique callable containing `node`.
     *
     * An Actions AST node may have multiple parent paths, but they converge on
     * the same root.
     */
    Callable getEnclosingCallable(AstNode node) {
      result = node
      or
      not node instanceof Callable and
      result = getEnclosingCallable(node.getParentNode())
    }

    class Parameter extends AstNode {
      Parameter() { none() }

      AstNode getPattern() { none() }

      Expr getDefaultValue() { none() }
    }

    Parameter callableGetParameter(Callable callable, int index) { none() }

    class Stmt extends AstNode {
      Stmt() { none() }
    }

    class LabeledStmt extends Stmt {
      LabeledStmt() { none() }

      Stmt getStmt() { none() }
    }

    class Expr extends AstNode {
      Expr() { none() }
    }

    class BlockStmt extends Stmt {
      BlockStmt() { none() }

      Stmt getStmt(int index) { none() }

      Stmt getLastStmt() { none() }
    }

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

    class LoopStmt extends Stmt {
      LoopStmt() { none() }

      Stmt getBody() { none() }
    }

    class WhileStmt extends LoopStmt {
      WhileStmt() { none() }

      Expr getCondition() { none() }
    }

    class DoStmt extends LoopStmt {
      DoStmt() { none() }

      Expr getCondition() { none() }
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

    class ForEachStmt extends LoopStmt {
      ForEachStmt() { none() }

      Expr getVariable() { none() }

      Expr getCollection() { none() }
    }

    class BreakStmt extends Stmt {
      BreakStmt() { none() }
    }

    class ContinueStmt extends Stmt {
      ContinueStmt() { none() }
    }

    class GotoStmt extends Stmt {
      GotoStmt() { none() }
    }

    class ReturnStmt extends Stmt {
      ReturnStmt() { none() }

      Expr getExpr() { none() }
    }

    class Throw extends AstNode {
      Throw() { none() }

      Expr getExpr() { none() }
    }

    class TryStmt extends Stmt {
      TryStmt() { none() }

      AstNode getBody(int index) { none() }

      CatchClause getCatch(int index) { none() }

      Stmt getFinally() { none() }
    }

    class CatchClause extends AstNode {
      CatchClause() { none() }

      AstNode getPattern() { none() }

      AstNode getVariable() { none() }

      Expr getCondition() { none() }

      Stmt getBody() { none() }
    }

    class Switch extends AstNode {
      Switch() { none() }

      Expr getExpr() { none() }

      Case getCase(int index) { none() }

      Stmt getStmt(int index) { none() }
    }

    class Case extends AstNode {
      Case() { none() }

      AstNode getPattern(int index) { none() }

      Expr getGuard() { none() }

      AstNode getBody() { none() }
    }

    class DefaultCase extends Case {
      DefaultCase() { none() }
    }

    class ConditionalExpr extends Expr {
      ConditionalExpr() { none() }

      Expr getCondition() { none() }

      Expr getThen() { none() }

      Expr getElse() { none() }
    }

    class BinaryExpr extends Expr {
      BinaryExpr() { none() }

      Expr getLeftOperand() { none() }

      Expr getRightOperand() { none() }
    }

    class LogicalAndExpr extends BinaryExpr {
      LogicalAndExpr() { none() }
    }

    class LogicalOrExpr extends BinaryExpr {
      LogicalOrExpr() { none() }
    }

    class NullCoalescingExpr extends BinaryExpr {
      NullCoalescingExpr() { none() }
    }

    class UnaryExpr extends Expr {
      UnaryExpr() { none() }

      Expr getOperand() { none() }
    }

    class LogicalNotExpr extends UnaryExpr {
      LogicalNotExpr() { none() }
    }

    class Assignment extends BinaryExpr {
      Assignment() { none() }
    }

    class AssignExpr extends Assignment {
      AssignExpr() { none() }
    }

    class CompoundAssignment extends Assignment {
      CompoundAssignment() { none() }
    }

    class AssignLogicalAndExpr extends CompoundAssignment {
      AssignLogicalAndExpr() { none() }
    }

    class AssignLogicalOrExpr extends CompoundAssignment {
      AssignLogicalOrExpr() { none() }
    }

    class AssignNullCoalescingExpr extends CompoundAssignment {
      AssignNullCoalescingExpr() { none() }
    }

    class BooleanLiteral extends Expr {
      BooleanLiteral() { none() }

      boolean getValue() { none() }
    }

    class PatternMatchExpr extends Expr {
      PatternMatchExpr() { none() }

      Expr getExpr() { none() }

      AstNode getPattern() { none() }
    }
  }

  private module Cfg0 = CfgShared::Make0<Location, CfgAst>;

  private module Input1 implements Cfg0::InputSig1 {
    predicate cfgCachedStageRef() { CfgCachedStage::ref() }

    class Label = Void;

    class CallableContext = Void;
  }

  private module Cfg1 = Cfg0::Make1<Input1>;

  private module Input2 implements Cfg1::InputSig2 {
    predicate beginAbruptCompletion(
      AstNode ast, PreControlFlowNode node, AbruptCompletion completion, boolean always
    ) {
      none()
    }

    predicate endAbruptCompletion(AstNode ast, PreControlFlowNode node, AbruptCompletion completion) {
      none()
    }

    predicate step(PreControlFlowNode predecessor, PreControlFlowNode successor) { none() }
  }

  private module Cfg2 = Cfg1::Make2<Input2>;

  private import Cfg0
  private import Cfg1
  private import Cfg2
  import Public
  import ControlFlow

  class CfgScope = CfgAst::Callable;

  /** A CFG scope for a workflow. */
  class WorkflowScope extends CfgScope instanceof Workflow { }

  /** A CFG scope for a composite action. */
  class CompositeActionScope extends CfgScope instanceof CompositeAction { }

  /** A control flow node. */
  class Node = ControlFlowNode;

  /** The control flow node at the entry point of a scope. */
  class EntryNode = ControlFlow::EntryNode;

  /** A control flow node indicating normal or exceptional termination of a scope. */
  class AnnotatedExitNode = ControlFlow::AnnotatedExitNode;

  /** A control flow node indicating normal termination of a scope. */
  class NormalExitNode = ControlFlow::NormalExitNode;

  /** A control flow node indicating exceptional termination of a scope. */
  class ExceptionalExitNode = ControlFlow::ExceptionalExitNode;

  /** A control flow node indicating the termination of a scope. */
  class ExitNode = ControlFlow::ExitNode;

  /**
   * A node that uniquely represents an AST node.
   *
   * Unreachable AST nodes do not have an `AstCfgNode`.
   */
  class AstCfgNode extends Node {
    AstCfgNode() { this.injects(_) }

    AstNode getAstNode() { this.injects(result) }
  }
}
