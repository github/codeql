/**
 * Provides classes and predicates for working with basic blocks in Java.
 */
overlay[local?]
module;

import java
import Dominance
private import codeql.controlflow.BasicBlock as BB

private module Input implements BB::InputSig<Location> {
  import SuccessorType

  /** Hold if `t` represents a conditional successor type. */
  predicate successorTypeIsCondition(SuccessorType t) { none() }

  /** A delineated part of the AST with its own CFG. */
  class CfgScope = Callable;

  /** The class of control flow nodes. */
  class Node = ControlFlowNode;

  /** Gets the CFG scope in which this node occurs. */
  CfgScope nodeGetCfgScope(Node node) { node.getEnclosingCallable() = result }

  private Node getASpecificSuccessor(Node node, SuccessorType t) {
    node.(ConditionNode).getABranchSuccessor(t.(BooleanSuccessor).getValue()) = result
    or
    node.getAnExceptionSuccessor() = result and t instanceof ExceptionSuccessor
  }

  /** Gets an immediate successor of this node. */
  Node nodeGetASuccessor(Node node, SuccessorType t) {
    result = getASpecificSuccessor(node, t)
    or
    node.getASuccessor() = result and
    t instanceof NormalSuccessor and
    not result = getASpecificSuccessor(node, _)
  }

  /**
   * Holds if `node` represents an entry node to be used when calculating
   * dominance.
   */
  predicate nodeIsDominanceEntry(Node node) {
    exists(Stmt entrystmt | entrystmt = node.asStmt() |
      exists(Callable c | entrystmt = c.getBody())
      or
      // This disjunct is technically superfluous, but safeguards against extractor problems.
      entrystmt instanceof BlockStmt and
      not exists(entrystmt.getEnclosingCallable()) and
      not entrystmt.getParent() instanceof Stmt
    )
  }

  /**
   * Holds if `node` represents an exit node to be used when calculating
   * post dominance.
   */
  predicate nodeIsPostDominanceExit(Node node) { node instanceof ControlFlow::ExitNode }
}

private module BbImpl = BB::Make<Location, Input>;

import BbImpl

/** Holds if the dominance relation is calculated for `bb`. */
predicate hasDominanceInformation(BasicBlock bb) {
  exists(BasicBlock entry |
    Input::nodeIsDominanceEntry(entry.getFirstNode()) and entry.getASuccessor*() = bb
  )
}

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
class BasicBlock extends BbImpl::BasicBlock {
  /** Gets the immediately enclosing callable whose body contains this node. */
  Callable getEnclosingCallable() { result = this.getScope() }

  /**
   * Holds if this basic block dominates basic block `bb`.
   *
   * That is, all paths reaching `bb` from the entry point basic block must
   * go through this basic block.
   */
  predicate dominates(BasicBlock bb) { super.dominates(bb) }

  /**
   * Holds if this basic block strictly dominates basic block `bb`.
   *
   * That is, all paths reaching `bb` from the entry point basic block must
   * go through this basic block and this basic block is different from `bb`.
   */
  predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessor(Input::SuccessorType t) { result = super.getASuccessor(t) }

  /**
   * DEPRECATED: Use `getASuccessor` instead.
   *
   * Gets an immediate successor of this basic block.
   */
  deprecated BasicBlock getABBSuccessor() { result = this.getASuccessor() }

  /**
   * DEPRECATED: Use `getAPredecessor` instead.
   *
   * Gets an immediate predecessor of this basic block.
   */
  deprecated BasicBlock getABBPredecessor() { result.getASuccessor() = this }

  /**
   * DEPRECATED: Use `strictlyDominates` instead.
   *
   * Holds if this basic block strictly dominates `node`.
   */
  deprecated predicate bbStrictlyDominates(BasicBlock node) { this.strictlyDominates(node) }

  /**
   * DEPRECATED: Use `dominates` instead.
   *
   * Holds if this basic block dominates `node`. (This is reflexive.)
   */
  deprecated predicate bbDominates(BasicBlock node) { this.dominates(node) }

  /**
   * DEPRECATED: Use `strictlyPostDominates` instead.
   *
   * Holds if this basic block strictly post-dominates `node`.
   */
  deprecated predicate bbStrictlyPostDominates(BasicBlock node) { this.strictlyPostDominates(node) }

  /**
   * DEPRECATED: Use `postDominates` instead.
   *
   * Holds if this basic block post-dominates `node`. (This is reflexive.)
   */
  deprecated predicate bbPostDominates(BasicBlock node) { this.postDominates(node) }
}

/** A basic block that ends in an exit node. */
class ExitBlock extends BasicBlock {
  ExitBlock() { this.getLastNode() instanceof ControlFlow::ExitNode }
}
