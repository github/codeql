private import codeql.actions.Ast
private import codeql.controlflow.Cfg as CfgShared
private import codeql.Locations

module Completion {
  private newtype TCompletion =
    TSimpleCompletion() or
    TBooleanCompletion(boolean b) { b in [false, true] } or
    TReturnCompletion()

  abstract class Completion extends TCompletion {
    abstract string toString();

    predicate isValidForSpecific(AstNode e) { none() }

    predicate isValidFor(AstNode e) { this.isValidForSpecific(e) }

    abstract SuccessorType getAMatchingSuccessorType();
  }

  abstract class NormalCompletion extends Completion { }

  class SimpleCompletion extends NormalCompletion, TSimpleCompletion {
    override string toString() { result = "SimpleCompletion" }

    override predicate isValidFor(AstNode e) { not any(Completion c).isValidForSpecific(e) }

    override NormalSuccessor getAMatchingSuccessorType() { any() }
  }

  class BooleanCompletion extends NormalCompletion, TBooleanCompletion {
    boolean value;

    BooleanCompletion() { this = TBooleanCompletion(value) }

    override string toString() { result = "BooleanCompletion(" + value + ")" }

    override predicate isValidForSpecific(AstNode e) {
      none()
      // TODO: add support for conditional expressions?
      //e = any(ConditionalExpression c).getCondition()
    }

    override BooleanSuccessor getAMatchingSuccessorType() { result.getValue() = value }

    final boolean getValue() { result = value }
  }

  class ReturnCompletion extends Completion, TReturnCompletion {
    override string toString() { result = "ReturnCompletion" }

    override predicate isValidForSpecific(AstNode e) { none() }

    override ReturnSuccessor getAMatchingSuccessorType() { any() }
  }

  cached
  private newtype TSuccessorType =
    TNormalSuccessor() or
    TBooleanSuccessor(boolean b) { b in [false, true] } or
    TReturnSuccessor()

  class SuccessorType extends TSuccessorType {
    string toString() { none() }
  }

  class NormalSuccessor extends SuccessorType, TNormalSuccessor {
    override string toString() { result = "successor" }
  }

  class BooleanSuccessor extends SuccessorType, TBooleanSuccessor {
    boolean value;

    BooleanSuccessor() { this = TBooleanSuccessor(value) }

    override string toString() { result = value.toString() }

    boolean getValue() { result = value }
  }

  class ReturnSuccessor extends SuccessorType, TReturnSuccessor {
    override string toString() { result = "return" }
  }
  // Why is there no conditional successor type?
}

module CfgScope {
  abstract class CfgScope extends AstNode { }

  class WorkflowScope extends CfgScope instanceof WorkflowStmt { }
}

private module Implementation implements CfgShared::InputSig<Location> {
  import codeql.actions.Ast
  import Completion
  import CfgScope

  predicate completionIsNormal(Completion c) { not c instanceof ReturnCompletion }

  // Not using CFG splitting, so the following are just dummy types.
  private newtype TUnit = Unit()

  class SplitKindBase = TUnit;

  class Split extends TUnit {
    abstract string toString();
  }

  predicate completionIsSimple(Completion c) { c instanceof SimpleCompletion }

  predicate completionIsValidFor(Completion c, AstNode e) { c.isValidFor(e) }

  CfgScope getCfgScope(AstNode e) {
    exists(AstNode p | p = e.getParentNode() |
      result = p
      or
      not p instanceof CfgScope and result = getCfgScope(p)
    )
  }

  int maxSplits() { result = 0 }

  predicate scopeFirst(CfgScope scope, AstNode e) { first(scope.(WorkflowStmt), e) }

  predicate scopeLast(CfgScope scope, AstNode e, Completion c) { last(scope.(WorkflowStmt), e, c) }

  predicate successorTypeIsSimple(SuccessorType t) { t instanceof NormalSuccessor }

  predicate successorTypeIsCondition(SuccessorType t) { t instanceof BooleanSuccessor }

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate isAbnormalExitType(SuccessorType t) { none() }
}

module CfgImpl = CfgShared::Make<Location, Implementation>;

private import CfgImpl
private import Completion
private import CfgScope

private class WorkflowTree extends StandardPreOrderTree instanceof WorkflowStmt {
  override ControlFlowTree getChildNode(int i) {
    if this instanceof ReusableWorkflowStmt
    then
      result =
        rank[i](Expression child, Location l |
          (
            child = this.(ReusableWorkflowStmt).getInputsStmt() or
            child = this.(ReusableWorkflowStmt).getOutputsStmt() or
            child = this.(ReusableWorkflowStmt).getAJobStmt()
          ) and
          l = child.getLocation()
        |
          child
          order by
            l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
        )
    else
      result =
        rank[i](Expression child, Location l |
          child = super.getAJobStmt() and
          l = child.getLocation()
        |
          child
          order by
            l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
        )
  }
}

private class ReusableWorkflowInputsTree extends StandardPreOrderTree instanceof ReusableWorkflowInputsStmt
{
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        child = super.getInputExpr(_) and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class InputExprTree extends LeafTree instanceof ReusableWorkflowInputExpr { }

private class ReusableWorkflowOutputsTree extends StandardPreOrderTree instanceof ReusableWorkflowOutputsStmt
{
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        child = super.getOutputExpr(_) and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class OutputExprTree extends LeafTree instanceof ReusableWorkflowOutputExpr { }

private class JobTree extends StandardPreOrderTree instanceof JobStmt {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        (
          child = super.getAStepStmt() or
          child = super.getOutputStmt() or
          child = super.getUsesExpr()
        ) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class JobOutputTree extends StandardPreOrderTree instanceof JobOutputStmt {
  override ControlFlowTree getChildNode(int i) { result = super.asYamlMapping().getValueNode(i) }
}

private class StepUsesTree extends StandardPreOrderTree instanceof StepUsesExpr {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        child = super.getArgumentExpr(_) and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class JobUsesTree extends StandardPreOrderTree instanceof JobUsesExpr {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        child = super.getArgumentExpr(_) and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class RunTree extends StandardPreOrderTree instanceof RunExpr {
  //override ControlFlowTree getChildNode(int i) { result = super.getScriptExpr() and i = 0 }
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        (child = super.getEnvExpr(_) or child = super.getScriptExpr()) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class ExprAccessTree extends LeafTree instanceof ExprAccessExpr { }
