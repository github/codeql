private import csharp as CS
private import ControlFlowGraphImpl as Impl
private import Completion as Comp
private import Splitting as Splitting
private import SuccessorType as ST
private import semmle.code.csharp.Caching

class ControlFlowTreeBase = Impl::ControlFlowTree::Range;

class ControlFlowElement = CS::ControlFlowElement;

class Completion = Comp::Completion;

/**
 * Hold if `c` represents normal evaluation of a statement or an
 * expression.
 */
predicate completionIsNormal(Completion c) { c instanceof Comp::NormalCompletion }

/**
 * Hold if `c` represents simple (normal) evaluation of a statement or an
 * expression.
 */
predicate completionIsSimple(Completion c) { c instanceof Comp::SimpleCompletion }

/** Holds if `c` is a valid completion for `e`. */
predicate completionIsValidFor(Completion c, ControlFlowElement e) { c.isValidFor(e) }

class CfgScope = Impl::CfgScope;

/** Gets the CFG scope for `e`. */
CfgScope getCfgScope(ControlFlowElement e) {
  Stages::ControlFlowStage::forceCachingInSameStage() and
  result = e.getEnclosingCallable()
}

predicate scopeFirst = Impl::scopeFirst/2;

predicate scopeLast = Impl::scopeLast/3;

/** The maximum number of splits allowed for a given node. */
int maxSplits() { result = 5 }

class SplitKindBase = Splitting::TSplitKind;

class Split = Splitting::Split;

class SuccessorType = ST::SuccessorType;

/** Gets a successor type that matches completion `c`. */
SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

/**
 * Hold if `c` represents simple (normal) evaluation of a statement or an
 * expression.
 */
predicate successorTypeIsSimple(SuccessorType t) {
  t instanceof ST::SuccessorTypes::NormalSuccessor
}

/** Holds if `t` is an abnormal exit type out of a callable. */
predicate isAbnormalExitType(SuccessorType t) {
  t instanceof ST::SuccessorTypes::ExceptionSuccessor or
  t instanceof ST::SuccessorTypes::ExitSuccessor
}

class Location = CS::Location;

class Node = CS::ControlFlow::Node;
