import cpp
import BasicBlocks
private import semmle.code.cpp.controlflow.internal.ConstantExprs

/**
 * A control-flow node is either a statement or an expression; in addition,
 * functions are control-flow nodes representing the exit point of the
 * function. The graph represents one possible evaluation order out of all the
 * ones the compiler might have picked.
 *
 * Control-flow nodes have successors and predecessors at the expression level,
 * so control flow is accurately represented in expressions as well as between
 * statements. Statements and initializers precede their contained expressions,
 * and expressions deeper in the tree precede those higher up; for example, the
 * statement `x = y + 1` gets a control-flow graph that looks like
 *
 * ```
 * ExprStmt -> y -> 1 -> (+) -> x -> (=)
 * ```
 *
 * The first control-flow node in a function is the body of the function (a
 * block), and the last is the function itself, which is used to represent the
 * exit point.
 *
 * Each `throw` expression or `Handler` has a path (along any necessary
 * destructor calls) to its nearest enclosing `Handler` within the same
 * function, or to the exit point of the function if there is no such
 * `Handler`. There are no edges from function calls to `Handler`s.
 */
class ControlFlowNode extends Locatable, @cfgnode {

  ControlFlowNode getASuccessor() { successors_adapted(unresolveElement(this),unresolveElement(result)) }

  ControlFlowNode getAPredecessor() { this = result.getASuccessor() }

  /** Gets the function containing this control-flow node. */
  abstract Function getControlFlowScope();

  /** Gets the smallest statement containing this control-flow node. */
  abstract Stmt getEnclosingStmt();

  /**
   * Holds if this node is the top-level expression of a conditional statement,
   * meaning that `this.getATrueSuccessor()` or `this.getAFalseSuccessor()`
   * will have a result.
   */
  predicate isCondition() {
    exists(this.getATrueSuccessor()) or
    exists(this.getAFalseSuccessor())
  }

  /**
   * Gets a node such that the control-flow edge `(this, result)` may be
   * taken when this expression is true.
   */
  ControlFlowNode getATrueSuccessor() {
    truecond(unresolveElement(this),unresolveElement(result)) and result = getASuccessor()
  }

  /**
   * Gets a node such that the control-flow edge `(this, result)` may be
   * taken when this expression is false.
   */
  ControlFlowNode getAFalseSuccessor() {
    falsecond(unresolveElement(this),unresolveElement(result)) and result = getASuccessor()
  }

  BasicBlock getBasicBlock() {
    result.getANode() = this
  }
}

import Cached
private cached module Cached {
  /**
   * Holds if the control-flow node `n` is reachable, meaning that either
   * it is an entry point, or there exists a path in the control-flow
   * graph of its function that connects an entry point to it.
   * Compile-time constant conditions are taken into account, so that
   * the call to `f` is not reachable in `if (0) f();` even if the
   * `if` statement as a whole is reachable.
   */
  cached
  predicate reachable(ControlFlowNode n)
  {
    exists(Function f | f.getEntryPoint() = n)
    or
    // Okay to use successors_extended directly here
    (not successors_extended(_,unresolveElement(n)) and not successors_extended(unresolveElement(n),_))
    or
    reachable(n.getAPredecessor())
    or
    n instanceof CatchBlock
  }

  /** Holds if `condition` always evaluates to a nonzero value. */
  cached
  predicate conditionAlwaysTrue(Expr condition) {
    conditionAlways(condition, true)
  }

  /** Holds if `condition` always evaluates to zero. */
  cached
  predicate conditionAlwaysFalse(Expr condition) {
    conditionAlways(condition, false)
    or
    // If a loop condition evaluates to false upon entry, it will always
    // be false
    loopConditionAlwaysUponEntry(_, condition, false)
  }

  /**
   * The condition `condition` for the loop `loop` is provably `true` upon entry.
   * That is, at least one iteration of the loop is guaranteed.
   */
  cached
  predicate loopConditionAlwaysTrueUponEntry(ControlFlowNode loop, Expr condition) {
    loopConditionAlwaysUponEntry(loop, condition, true)
  }
}

private predicate conditionAlways(Expr condition, boolean b) {
  exists(ConditionEvaluator x, int val |
    val = x.getValue(condition) |
    val != 0 and b = true
    or
    val = 0 and b = false
  )
}

private predicate loopConditionAlwaysUponEntry(ControlFlowNode loop, Expr condition, boolean b) {
  exists(LoopEntryConditionEvaluator x, int val |
    x.isLoopEntry(condition, loop) and
    val = x.getValue(condition) |
    val != 0 and b = true
    or
    val = 0 and b = false
  )
}

/**
 * An abstract class that can be extended to add additional edges to the
 * control-flow graph. Instances of this class correspond to the source nodes
 * of such edges, and the predicate `getAnEdgeTarget` should be overridden to
 * produce the target nodes of each source.
 *
 * Changing the control-flow graph in some queries and not others can be
 * expensive in execution time and disk space. Most cached predicates in the
 * library depend on the control-flow graph, so these predicates will be
 * computed and cached for each variation of the control-flow graph
 * that is used.
 *
 * Edges added by this class will still be removed by the library if they
 * appear to be unreachable. See the documentation on `ControlFlowNode` for
 * more information about the control-flow graph.
 */
abstract class AdditionalControlFlowEdge extends @cfgnode {
  /** Gets a target node of this edge, where the source node is `this`. */
  abstract ControlFlowNode getAnEdgeTarget();

  string toString() { result = mkElement(this).(ControlFlowNode).toString() }
}

/**
 * Holds if there is a control-flow edge from `source` to `target` in either
 * the extractor-generated control-flow graph or in a subclass of
 * `AdditionalControlFlowEdge`. Use this relation instead of `successors`.
 */
predicate successors_extended(@cfgnode source, @cfgnode target) {
  successors(source, target)
  or
  source.(AdditionalControlFlowEdge).getAnEdgeTarget() = mkElement(target)
}
