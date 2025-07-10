/**
 * @name Illegal invocation
 * @description Attempting to invoke a method or an arrow function using 'new',
 *              or invoking a constructor as a function, will cause a runtime
 *              error.
 * @kind problem
 * @problem.severity error
 * @id js/illegal-invocation
 * @tags correctness
 *       language-features
 * @precision high
 */

import javascript

/**
 * Holds if call site `cs` may invoke function `callee` as specified by `how`.
 */
predicate calls(DataFlow::InvokeNode cs, Function callee, string how) {
  callee = cs.getACallee() and
  (
    cs instanceof DataFlow::CallNode and
    not cs.asExpr() instanceof SuperCall and
    how = "as a function"
    or
    cs instanceof DataFlow::NewNode and
    how = "using 'new'"
  )
}

/**
 * Holds if call site `cs` may illegally invoke function `callee` as specified by `how`;
 * `calleeDesc` describes what kind of function `callee` is.
 */
predicate illegalInvocation(DataFlow::InvokeNode cs, Function callee, string calleeDesc, string how) {
  calls(cs, callee, how) and
  (
    how = "as a function" and
    callee instanceof Constructor and
    calleeDesc = "a constructor"
    or
    how = "using 'new'" and
    callee.isNonConstructible(calleeDesc)
  )
}

/**
 * Holds if `ce` is a call with at least one call target that isn't a constructor.
 */
predicate isCallToFunction(DataFlow::InvokeNode ce) {
  ce instanceof DataFlow::CallNode and
  exists(Function f | f = ce.getACallee() | not f instanceof Constructor)
}

from DataFlow::InvokeNode cs, Function callee, string calleeDesc, string how
where
  illegalInvocation(cs, callee, calleeDesc, how) and
  // filter out some easy cases
  not isCallToFunction(cs) and
  // conservatively only flag call sites where _all_ callees are illegal
  forex(DataFlow::InvokeNode cs2, Function otherCallee |
    cs2.getInvokeExpr() = cs.getInvokeExpr() and otherCallee = cs2.getACallee()
  |
    illegalInvocation(cs, otherCallee, _, _)
  ) and
  // require that all callees are known
  not cs.isIncomplete()
select cs, "Illegal invocation of $@ " + how + ".", callee, calleeDesc
