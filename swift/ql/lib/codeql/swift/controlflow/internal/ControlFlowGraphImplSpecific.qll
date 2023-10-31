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

/** Gets the maximum number of splits allowed for a given node. */
int maxSplits() { result = 5 }

class Location = S::Location;

class Node = CFG::ControlFlowNode;
