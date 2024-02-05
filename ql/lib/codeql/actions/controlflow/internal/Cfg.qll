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

  private class JobScope extends CfgScope instanceof JobStmt { }
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

  predicate scopeFirst(CfgScope scope, AstNode e) { first(scope.(JobStmt), e) }

  predicate scopeLast(CfgScope scope, AstNode e, Completion c) { last(scope.(JobStmt), e, c) }

  predicate successorTypeIsSimple(SuccessorType t) { t instanceof NormalSuccessor }

  predicate successorTypeIsCondition(SuccessorType t) { t instanceof BooleanSuccessor }

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate isAbnormalExitType(SuccessorType t) { none() }
}

module CfgImpl = CfgShared::Make<Location, Implementation>;

private import CfgImpl
private import Completion
private import CfgScope

// Trees are what end up creating Cfg::Node objects and therefore DataFlow::Node objects.
// Its also required that there is parent/child relationships between nodes so orphans nodes will not appear as either Cfg::Node or DataFlow::Node.
// For example
// - ArgumentExpr should be children of UsesExpr, and UsesExpr should be children of StepStmt.
// TODO: We need to make VarAccess expressions part ot the tree as they are currently orphans
private class CfgNodeTree extends StandardPreOrderTree instanceof AstNode {
  override AstNode getChildNode(int i) { result = super.getChildNodeByOrder(i) }
}
// private class JobStmtTree extends StandardPreOrderTree instanceof JobStmt {
//   override ControlFlowTree getChildNode(int i) { result = super.getSuccNode(i) }
// }
//
// private class StepStmtTree extends StandardPreOrderTree instanceof StepStmt {
//   override ControlFlowTree getChildNode(int i) { result = super.getSuccNode(i) }
// }
//
// private class JobOutputTree extends StandardPreOrderTree instanceof JobOutputStmt {
//   override ControlFlowTree getChildNode(int i) { result = super.getSuccNode(i) }
// }
//
// // TODO: Do we need this or we can just care about the ExprAccessExpr
// private class ArgumentTree extends LeafTree instanceof ArgumentExpr { }
//
// private class ExprAccessTree extends LeafTree instanceof ExprAccessExpr { }
//
// private class StepOutputAccessTree extends LeafTree instanceof StepOutputAccessExpr { }
//
// private class JobOutputAccessTree extends LeafTree instanceof JobOutputAccessExpr { }