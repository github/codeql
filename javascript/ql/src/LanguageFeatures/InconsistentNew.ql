/**
 * @name Inconsistent use of 'new'
 * @description If a function is intended to be a constructor, it should always
 *              be invoked with 'new'. Otherwise, it should always be invoked
 *              as a normal function, that is, without 'new'.
 * @kind problem
 * @problem.severity warning
 * @id js/inconsistent-use-of-new
 * @tags reliability
 *       correctness
 *       language-features
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if `f` contains code to guard against being invoked without `new`.
 *
 * There are many ways to implement such a check, but ultimately `f` will
 * have to call itself using `new`, so that is what we look for.
 */
predicate guardsAgainstMissingNew(Function f) {
  exists (DataFlow::NewNode new |
    new.asExpr().getEnclosingFunction() = f and
    f = new.getACallee()
  )
}

/**
 * Holds if `callee` is a function that may be invoked at callsite `cs`,
 * where `imprecision` is a heuristic measure of how likely it is that `callee`
 * is only suggested as a potential callee due to imprecise analysis of global
 * variables and is not, in fact, a viable callee at all.
 */
predicate calls(DataFlow::InvokeNode cs, Function callee, int imprecision) {
  callee = cs.getACallee() and
  (
    // if global flow was used to derive the callee, we may be imprecise
    if cs.isIndefinite("global") then
      // callees within the same file are probably genuine
      callee.getFile() = cs.getFile() and imprecision = 0
      or
      // calls to global functions declared in an externs file are fairly
      // safe as well
      callee.inExternsFile() and imprecision = 1
      or
      // otherwise we make worst-case assumptions
      imprecision = 2
    else
      // no global flow, so no imprecision
      imprecision = 0
  )
}

/**
 * Gets a function that may be invoked at `cs`, preferring callees that
 * are less likely to be derived due to analysis imprecision.
 */
Function getALikelyCallee(DataFlow::InvokeNode cs) {
  calls(cs, result, min(int p | calls(cs, _, p)))
}

from Function f, DataFlow::NewNode new, DataFlow::CallNode call
where // externs are special, so don't flag them
      not f.inExternsFile() and
      // illegal constructor calls are flagged by query 'Illegal invocation',
      // so don't flag them
      not f instanceof Constructor and
      f = getALikelyCallee(new) and
      f = getALikelyCallee(call) and
      not guardsAgainstMissingNew(f) and
      not new.isUncertain() and
      not call.isUncertain() and
      // super constructor calls behave more like `new`, so don't flag them
      not call.asExpr() instanceof SuperCall and
      // don't flag if there is a receiver object
      not exists(call.getReceiver())
select (FirstLineOf)f, capitalize(f.describe()) + " is invoked as a constructor here $@, " +
      "and as a normal function here $@.", new, new.toString(), call, call.toString()
