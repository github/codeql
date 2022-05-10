private import ruby as RB
private import ControlFlowGraphImpl as Impl
private import Completion as Comp
private import codeql.ruby.ast.internal.Synthesis
private import Splitting as Splitting
private import codeql.ruby.CFG as CFG

/** The base class for `ControlFlowTree`. */
class ControlFlowTreeBase extends RB::AstNode {
  ControlFlowTreeBase() { not any(Synthesis s).excludeFromControlFlowTree(this) }
}

class ControlFlowElement = RB::AstNode;

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

class CfgScope = CFG::CfgScope;

predicate getCfgScope = Impl::getCfgScope/1;

/** Holds if `first` is first executed when entering `scope`. */
predicate scopeFirst(CfgScope scope, ControlFlowElement first) {
  scope.(Impl::CfgScope::Range_).entry(first)
}

/** Holds if `scope` is exited when `last` finishes with completion `c`. */
predicate scopeLast(CfgScope scope, ControlFlowElement last, Completion c) {
  scope.(Impl::CfgScope::Range_).exit(last, c)
}

/** The maximum number of splits allowed for a given node. */
int maxSplits() { result = 5 }

class SplitKindBase = Splitting::TSplitKind;

class Split = Splitting::Split;

class SuccessorType = CFG::SuccessorType;

/** Gets a successor type that matches completion `c`. */
SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

/**
 * Hold if `c` represents simple (normal) evaluation of a statement or an
 * expression.
 */
predicate successorTypeIsSimple(SuccessorType t) {
  t instanceof CFG::SuccessorTypes::NormalSuccessor
}

/** Holds if `t` is an abnormal exit type out of a CFG scope. */
predicate isAbnormalExitType(SuccessorType t) {
  t instanceof CFG::SuccessorTypes::RaiseSuccessor or
  t instanceof CFG::SuccessorTypes::ExitSuccessor
}

class Location = RB::Location;

class Node = CFG::CfgNode;
