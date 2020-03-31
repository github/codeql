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
  exists(DataFlow::NewNode new |
    new.asExpr().getEnclosingFunction() = f and
    f = new.getACallee()
  )
}

/**
 * Gets a function that may be invoked at `cs`, preferring callees that
 * are less likely to be derived due to analysis imprecision and excluding
 * whitelisted call sites and callees. Additionally, `isNew` is bound to
 * `true` if `cs` is a `new` expression, and to `false` otherwise.
 */
Function getALikelyCallee(DataFlow::InvokeNode cs, boolean isNew) {
  result =
    min(Function callee, int imprecision |
      callee = cs.getACallee(imprecision)
    |
      callee order by imprecision
    ) and
  not cs.isUncertain() and
  not whitelistedCall(cs) and
  not whitelistedCallee(result) and
  (
    cs instanceof DataFlow::NewNode and isNew = true
    or
    cs instanceof DataFlow::CallNode and isNew = false
  )
}

/**
 * Holds if `f` should be whitelisted, either because it guards against
 * inconsistent `new` or we do not want to report it.
 */
predicate whitelistedCallee(Function f) {
  // externs are special, so don't flag them
  f.inExternsFile()
  or
  // illegal constructor calls are flagged by query 'Illegal invocation',
  // so don't flag them
  f instanceof Constructor
  or
  // if `f` itself guards against missing `new`, don't flag it
  guardsAgainstMissingNew(f)
}

/**
 * Holds if `call` should be whitelisted because it cannot cause problems
 * with inconsistent `new`.
 */
predicate whitelistedCall(DataFlow::CallNode call) {
  // super constructor calls behave more like `new`, so don't flag them
  call.asExpr() instanceof SuperCall
  or
  // don't flag if there is a receiver object
  exists(call.getReceiver())
}

/**
 * Get the `new` or call (depending on whether `isNew` is true or false) of `f`
 * that comes first under a lexicographical ordering by file path, start line
 * and start column.
 */
DataFlow::InvokeNode getFirstInvocation(Function f, boolean isNew) {
  result =
    min(DataFlow::InvokeNode invk, string path, int line, int col |
      f = getALikelyCallee(invk, isNew) and invk.hasLocationInfo(path, line, col, _, _)
    |
      invk order by path, line, col
    )
}

from Function f, DataFlow::NewNode new, DataFlow::CallNode call
where
  new = getFirstInvocation(f, true) and
  call = getFirstInvocation(f, false)
select f.(FirstLineOf),
  capitalize(f.describe()) + " is sometimes invoked as a constructor " +
    "(for example $@), and sometimes as a normal function (for example $@).", new, "here", call,
  "here"
