/**
 * @name Global variable may be used before initialization
 * @description Using an uninitialized variable may lead to undefined results.
 * @kind problem
 * @id cpp/global-use-before-init
 * @problem.severity warning
 * @security-severity 7.8
 * @tags reliability
 *       security
 *       external/cwe/cwe-457
 */

import cpp
import semmle.code.cpp.pointsto.CallGraph

predicate initFunc(GlobalVariable v, Function f) {
  exists(VariableAccess access |
    v.getAnAccess() = access and
    access.isUsedAsLValue() and
    access.getEnclosingFunction() = f
  )
}

predicate useFunc(GlobalVariable v, Function f) {
  exists(VariableAccess access |
    v.getAnAccess() = access and
    access.isRValue() and
    access.getEnclosingFunction() = f
  ) and
  not initFunc(v, f)
}

predicate uninitialisedBefore(GlobalVariable v, Function f) {
  f.hasGlobalName("main") and
  not initialisedAtDeclaration(v) and
  not isStdlibVariable(v)
  or
  exists(Call call, Function g |
    uninitialisedBefore(v, g) and
    call.getEnclosingFunction() = g and
    (not functionInitialises(f, v) or locallyUninitialisedAt(v, call)) and
    resolvedCall(call, f)
  )
}

predicate functionInitialises(Function f, GlobalVariable v) {
  exists(Call call |
    call.getEnclosingFunction() = f and
    initialisedBy(v, call)
  )
}

// this predicate is restricted to global variables used in the
// same function as "call"
predicate locallyUninitialisedAt(GlobalVariable v, Call call) {
  functionInitialises(call.getEnclosingFunction(), v) and
  (
    firstCall(call)
    or
    exists(Call mid |
      locallyUninitialisedAt(v, mid) and not initialisedBy(v, mid) and callPair(mid, call)
    )
  )
}

predicate initialisedBy(GlobalVariable v, Call call) {
  exists(Function f |
    resolvedCall(call, f) and
    initialises(v, f)
  )
}

predicate initialises(GlobalVariable v, Function f) {
  initFunc(v, f)
  or
  exists(Function mid | initialises(v, mid) and allCalls(f, mid))
}

predicate firstCall(Call call) { beforeCall(call) }

predicate beforeCall(ControlFlowNode node) {
  exists(Function f | f.getBlock() = node)
  or
  exists(ControlFlowNode mid |
    beforeCall(mid) and
    not mid instanceof Call and
    node = mid.getASuccessor()
  )
}

predicate callPair(Call call, Call successor) { callReaches(call, successor) }

predicate callReaches(Call call, ControlFlowNode successor) {
  call.getASuccessor() = successor
  or
  exists(ControlFlowNode mid |
    callReaches(call, mid) and
    not mid instanceof Call and
    mid.getASuccessor() = successor
  )
}

/** Holds if `v` has an initializer. */
predicate initialisedAtDeclaration(GlobalVariable v) { exists(v.getInitializer()) }

/** Holds if `v` is a global variable that does not need to be initialized. */
predicate isStdlibVariable(GlobalVariable v) { v.hasGlobalName(["stdin", "stdout", "stderr"]) }

from GlobalVariable v, Function f
where
  uninitialisedBefore(v, f) and
  useFunc(v, f)
select f, "The variable $@ is used in this function but may not be initialized when it is called.",
  v, v.getName()
