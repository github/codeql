/**
 * Provides classes and predicates for analyzing mutexes and the control
 * flow regions where they might be locked.
 */

import cpp
import semmle.code.cpp.commons.Synchronization

/**
 * Holds if `cond` is a test for whether locking `access` succeeded,
 * and `failNode` is the control flow node we continue with if it did
 * not. Suitable locking statements may look like `if(tryLock(m))` or
 * like `if(lock(m) != 0)`.
 */
cached
predicate tryLockCondition(VariableAccess access, ControlFlowNode cond, ControlFlowNode failNode) {
  exists(FunctionCall call | lockCall(access, call) |
    cond = call and call.getAFalseSuccessor() = failNode
    or
    // Look for code like this:
    //
    //   if (pthread_mutex_lock(mtx) != 0) return -1;
    //
    cond = call.getParent*() and
    cond.isCondition() and
    failNode = cond.getASuccessor() and
    failNode instanceof BasicBlockWithReturn
  )
}

/**
 * A basic block that ends with a return statement.
 */
class BasicBlockWithReturn extends BasicBlock {
  BasicBlockWithReturn() { this.contains(any(ReturnStmt r)) }
}

/**
 * Holds if mutex variable `v` might be locked or unlocked during
 * function call `call`?
 */
private predicate lockedOrUnlockedInCall(Variable v, FunctionCall call) {
  lockCall(v.getAnAccess(), call)
  or
  unlockCall(v.getAnAccess(), call)
  or
  // Interprocedural analysis: look for mutexes which are locked or
  // unlocked in the body of the callee.
  exists(Function fcn, Variable x |
    fcn = call.getTarget() and
    lockedOrUnlockedInFunction(x, fcn)
  |
    // If `x` is one of the function's parameters, then map it to the
    // corresponding argument.
    if x = fcn.getAParameter()
    then exists(int i | x = fcn.getParameter(i) | v.getAnAccess() = call.getArgument(i))
    else v = x
  )
}

/**
 * Holds if mutex variable `v` might be locked or unlocked by this
 * function, either directly or indirectly (through a call to another
 * function).
 */
private predicate lockedOrUnlockedInFunction(Variable v, Function fcn) {
  exists(FunctionCall call |
    lockedOrUnlockedInCall(v, call) and
    call.getEnclosingFunction() = fcn
  )
}

/**
 * Holds if the mutex locked at `access` might still be locked after
 * control flow node `node` has executed. That is, the lock which was
 * obtained at `access` has not been canceled by a matching unlock or
 * superseded by a more recent call to the lock method.
 */
predicate lockedOnExit(VariableAccess access, ControlFlowNode node) {
  lockCall(access, node)
  or
  lockedOnEntry(access, node) and
  // Remove mutexes which are either unlocked by this statement or
  // superseded by a another call to the lock method.
  not lockedOrUnlockedInCall(access.getTarget(), node)
  or
  // Interprocedural analysis: if the node is a function call and a mutex
  // is still locked at the end of the function body, then it is also
  // locked after the function returns. Note that the Function object is
  // used to represent the exit node in the control flow graph.
  exists(Function fcn, Variable x, VariableAccess xAccess |
    fcn = node.(FunctionCall).getTarget() and
    lockedOnEntry(xAccess, fcn) and
    x = xAccess.getTarget()
  |
    // If `x` is one of the function's parameters, then map it to the
    // corresponding argument.
    if x = fcn.getAParameter()
    then exists(int i | x = fcn.getParameter(i) | access = node.(FunctionCall).getArgument(i))
    else access = xAccess
  )
}

/**
 * Holds if the mutex locked at `access` might still be locked before
 * control flow node `node` executes. That is, if it might be locked
 * after a predecessor of `node` has executed.
 */
predicate lockedOnEntry(VariableAccess access, ControlFlowNode node) {
  exists(ControlFlowNode prev |
    lockedOnExit(access, prev) and
    node = prev.getASuccessor() and
    // If we are on the false branch of a call to `try_lock` then the
    // mutex is not locked.
    not tryLockCondition(access, prev, node)
  )
}

/**
 * Holds if mutex `access` is locked either directly or indirectly by
 * this function call. This is a generalization of `lockCall`.
 */
predicate lockedInCall(VariableAccess access, FunctionCall call) {
  lockCall(access, call)
  or
  // Interprocedural analysis: look for mutexes which are locked in the
  // body of the callee.
  exists(Function fcn, Variable x, VariableAccess xAccess |
    fcn = call.getTarget() and
    pathToLock(xAccess, fcn.getEntryPoint()) and
    x = xAccess.getTarget()
  |
    // If `x` is one of the function's parameters, then map it to the
    // corresponding argument.
    if x = fcn.getAParameter()
    then exists(int i | x = fcn.getParameter(i) | access = call.getArgument(i))
    else access = xAccess
  )
}

/**
 * Holds if mutex `access` might be locked at `node` or one of its
 * successors.
 */
predicate pathToLock(VariableAccess access, ControlFlowNode node) {
  lockedInCall(access, node)
  or
  pathToLock(access, node.getASuccessor()) and
  not lockedOrUnlockedInCall(access.getTarget(), node)
}
