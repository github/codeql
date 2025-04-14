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

    override predicate isValidForSpecific(AstNode e) { none() }

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
}

module CfgScope {
  abstract class CfgScope extends AstNode { }

  class WorkflowScope extends CfgScope instanceof Workflow { }

  class CompositeActionScope extends CfgScope instanceof CompositeAction { }
}

private module Implementation implements CfgShared::InputSig<Location> {
  import codeql.actions.Ast
  import Completion
  import CfgScope

  predicate completionIsNormal(Completion c) { not c instanceof ReturnCompletion }

  // Not using CFG splitting, so the following are just dummy types.
  private newtype TUnit = Unit()

  additional class SplitKindBase = TUnit;

  additional class Split extends TUnit {
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

  additional int maxSplits() { result = 0 }

  predicate scopeFirst(CfgScope scope, AstNode e) {
    first(scope.(Workflow), e) or
    first(scope.(CompositeAction), e)
  }

  predicate scopeLast(CfgScope scope, AstNode e, Completion c) {
    last(scope.(Workflow), e, c) or
    last(scope.(CompositeAction), e, c)
  }

  predicate successorTypeIsSimple(SuccessorType t) { t instanceof NormalSuccessor }

  predicate successorTypeIsCondition(SuccessorType t) { t instanceof BooleanSuccessor }

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate isAbnormalExitType(SuccessorType t) { none() }

  int idOfAstNode(AstNode node) { none() }

  int idOfCfgScope(CfgScope scope) { none() }
}

module CfgImpl = CfgShared::Make<Location, Implementation>;

private import CfgImpl
private import Completion
private import CfgScope

private class CompositeActionTree extends StandardPreOrderTree instanceof CompositeAction {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        (
          child = this.(CompositeAction).getAnInput() or
          child = this.(CompositeAction).getOutputs() or
          child = this.(CompositeAction).getRuns()
        ) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class RunsTree extends StandardPreOrderTree instanceof Runs {
  override ControlFlowTree getChildNode(int i) { result = super.getStep(i) }
}

private class WorkflowTree extends StandardPreOrderTree instanceof Workflow {
  override ControlFlowTree getChildNode(int i) {
    if this instanceof ReusableWorkflow
    then
      result =
        rank[i](AstNode child, Location l |
          (
            child = this.(ReusableWorkflow).getAnInput() or
            child = this.(ReusableWorkflow).getOutputs() or
            child = this.(ReusableWorkflow).getStrategy() or
            child = this.(ReusableWorkflow).getAJob()
          ) and
          l = child.getLocation()
        |
          child
          order by
            l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
        )
    else
      result =
        rank[i](AstNode child, Location l |
          (
            child = super.getStrategy() or
            child = super.getAJob()
          ) and
          l = child.getLocation()
        |
          child
          order by
            l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
        )
  }
}

private class OutputsTree extends StandardPreOrderTree instanceof Outputs {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        child = super.getAnOutputExpr() and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class StrategyTree extends StandardPreOrderTree instanceof Strategy {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        child = super.getAMatrixVarExpr() and l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class JobTree extends StandardPreOrderTree instanceof LocalJob {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        (
          child = super.getAStep() or
          child = super.getOutputs() or
          child = super.getStrategy()
        ) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class ExternalJobTree extends StandardPreOrderTree instanceof ExternalJob {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        (
          child = super.getArgumentExpr(_) or
          child = super.getInScopeEnvVarExpr(_) or
          child = super.getOutputs() or
          child = super.getStrategy()
        ) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class UsesTree extends StandardPreOrderTree instanceof UsesStep {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        (child = super.getArgumentExpr(_) or child = super.getInScopeEnvVarExpr(_)) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class RunTree extends StandardPreOrderTree instanceof Run {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](AstNode child, Location l |
        (
          child = super.getInScopeEnvVarExpr(_) or
          child = super.getAnScriptExpr() or
          child = super.getScript()
        ) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class ScalarValueTree extends StandardPreOrderTree instanceof ScalarValue {
  override ControlFlowTree getChildNode(int i) {
    result =
      rank[i](Expression child, Location l |
        child = super.getAChildNode() and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

private class UsesLeaf extends LeafTree instanceof Uses { }

private class InputTree extends LeafTree instanceof Input { }

private class ScalarValueLeaf extends LeafTree instanceof ScalarValue { }

private class ExpressionLeaf extends LeafTree instanceof Expression { }
