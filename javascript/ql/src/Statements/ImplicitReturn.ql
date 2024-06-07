/**
 * @name Not all control paths return a value
 * @description Functions where some execution paths return an explicit value while others
 *              "fall off" the end of the function and return 'undefined' are hard to maintain and use.
 * @kind problem
 * @problem.severity recommendation
 * @id js/implicit-return
 * @tags maintainability
 * @precision medium
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if `s` is a statement that terminates execution of the surrounding method,
 * either by returning or throwing an exception. As a special case, we include calls
 * to functions whose name contains `"throw"`.
 */
predicate isThrowOrReturn(Stmt s) {
  s instanceof ReturnStmt or
  s instanceof ThrowStmt or
  s.(ExprStmt).getExpr().(CallExpr).getCalleeName().matches("%throw%")
}

/**
 * A `return` statement with an operand (that is, not just `return;`).
 */
class ValueReturn extends ReturnStmt {
  ValueReturn() { exists(this.getExpr()) }
}

/** Gets the lexically first explicit return statement in function `f`. */
ValueReturn getFirstExplicitReturn(Function f) {
  result =
    min(ValueReturn ret |
      ret.getContainer() = f
    |
      ret order by ret.getLocation().getStartLine(), ret.getLocation().getStartColumn()
    )
}

/** Gets the number of return statements in function `f`, assuming there is at least one. */
int numRet(Function f) { result = strictcount(ReturnStmt ret | ret.getContainer() = f) }

/**
 * Holds if `f` is a dual-use constructor, that is, is a function that is meant to be invoked
 * with `new` only, but guards against the case where it is invoked as a plain function.
 *
 * We consider a function to be a dual-use constructor if
 *
 * 1. it has a single `return` statement
 * 2. that `return` statement returns a `new` expression
 * 3. and the `new` expression instantiates the function itself
 */
predicate isDualUseConstructor(Function f) {
  numRet(f) = 1 and
  exists(ReturnStmt ret, DataFlow::NewNode new | ret.getContainer() = f |
    new.asExpr() = ret.getExpr().getUnderlyingValue() and
    new.getACallee() = f
  )
}

/**
 * Gets a fall-through statement in function `f`, that is, a statement that is reachable,
 * does not have a successor statement inside the function, isn't a throw or a return,
 * and isn't contained in a `finally` block.
 */
Stmt getAFallThroughStmt(Function f) {
  exists(ReachableBasicBlock bb, ControlFlowNode nd |
    bb.getANode() = nd and
    nd.isAFinalNode() and
    f = bb.getContainer() and
    (result = nd or result = nd.(Expr).getEnclosingStmt()) and
    not isThrowOrReturn(result) and
    not exists(TryStmt try | result.getParentStmt+() = try.getFinally())
  )
}

from Function f, Stmt fallthrough
where
  fallthrough = getAFallThroughStmt(f) and
  // no control path ends with an implicit return statement of the form `return;`
  not exists(ReturnStmt ret | ret.getContainer() = f and not exists(ret.getExpr())) and
  // f doesn't look like a dual-use constructor (which otherwise would trigger a violation)
  not isDualUseConstructor(f)
select fallthrough.(FirstLineOf),
  "$@ may implicitly return 'undefined' here, while $@ an explicit value is returned.", f,
  capitalize(f.describe()), getFirstExplicitReturn(f), "elsewhere"
