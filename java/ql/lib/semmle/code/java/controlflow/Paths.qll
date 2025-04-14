/**
 * This library provides predicates for reasoning about the set of all paths
 * through a callable.
 */

import java
import semmle.code.java.dispatch.VirtualDispatch

/**
 * A configuration to define an "action". The member predicates
 * `callableAlwaysPerformsAction` and `callAlwaysPerformsAction` then gives all
 * the callables and calls that always performs an action taking
 * inter-procedural flow into account.
 */
abstract class ActionConfiguration extends string {
  bindingset[this]
  ActionConfiguration() { any() }

  /** Holds if `node` is an action. */
  abstract predicate isAction(ControlFlowNode node);

  /** Holds if every path through `callable` goes through at least one action node. */
  final predicate callableAlwaysPerformsAction(Callable callable) {
    callableAlwaysPerformsAction(callable, this)
  }

  /** Holds if every path through `call` goes through at least one action node. */
  final predicate callAlwaysPerformsAction(Call call) { callAlwaysPerformsAction(call, this) }
}

/** Gets a `BasicBlock` that contains an action. */
private BasicBlock actionBlock(ActionConfiguration conf) {
  exists(ControlFlowNode node | result = node.getBasicBlock() |
    conf.isAction(node) or
    callAlwaysPerformsAction(node.asCall(), conf)
  )
}

/** Holds if every path through `call` goes through at least one action node. */
private predicate callAlwaysPerformsAction(Call call, ActionConfiguration conf) {
  forex(Callable callable | callable = viableCallable(call) |
    callableAlwaysPerformsAction(callable, conf)
  )
}

/** Holds if an action dominates the exit of the callable. */
private predicate actionDominatesExit(Callable callable, ActionConfiguration conf) {
  exists(ExitBlock exit |
    exit.getEnclosingCallable() = callable and
    actionBlock(conf).bbDominates(exit)
  )
}

/** Gets a `BasicBlock` that contains an action that does not dominate the exit. */
private BasicBlock nonDominatingActionBlock(ActionConfiguration conf) {
  exists(ExitBlock exit |
    result = actionBlock(conf) and
    exit.getEnclosingCallable() = result.getEnclosingCallable() and
    not result.bbDominates(exit)
  )
}

private class JoinBlock extends BasicBlock {
  JoinBlock() { 2 <= strictcount(this.getABBPredecessor()) }
}

/**
 * Holds if `bb` is a block that is collectively dominated by a set of one or
 * more actions that individually does not dominate the exit.
 */
private predicate postActionBlock(BasicBlock bb, ActionConfiguration conf) {
  bb = nonDominatingActionBlock(conf)
  or
  if bb instanceof JoinBlock
  then forall(BasicBlock pred | pred = bb.getABBPredecessor() | postActionBlock(pred, conf))
  else postActionBlock(bb.getABBPredecessor(), conf)
}

/** Holds if every path through `callable` goes through at least one action node. */
private predicate callableAlwaysPerformsAction(Callable callable, ActionConfiguration conf) {
  actionDominatesExit(callable, conf)
  or
  exists(ExitBlock exit |
    exit.getEnclosingCallable() = callable and
    postActionBlock(exit, conf)
  )
}
