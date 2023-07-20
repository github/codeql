private import swift as S
private import ControlFlowGraphImpl as Impl
import Completion
private import codeql.swift.controlflow.ControlFlowGraph as CFG
private import Splitting as Splitting
private import Scope
import ControlFlowElements
import AstControlFlowTrees

/** The base class for `ControlFlowTree`. */
class ControlFlowTreeBase = ControlFlowElement;

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

/** Gets the maximum number of splits allowed for a given node. */
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
  t instanceof CFG::SuccessorTypes::ExceptionSuccessor
}

class Location = S::Location;

class Node = CFG::ControlFlowNode;
