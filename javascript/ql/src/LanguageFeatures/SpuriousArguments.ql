/**
 * @name Superfluous trailing arguments
 * @description A function is invoked with extra trailing arguments that are ignored.
 * @kind problem
 * @problem.severity warning
 * @id js/superfluous-trailing-arguments
 * @tags maintainability
 *       correctness
 *       language-features
 *       external/cwe/cwe-685
 * @precision very-high
 */

import javascript

/**
 * Holds if `fn` expects a fixed number of arguments, that is,
 * it neither uses `arguments` nor has a rest parameter.
 */
predicate isFixedArity(Function fn) {
  not fn.usesArgumentsObject() and
  not fn.hasRestParameter() and
  not fn.(ExternalFunction).isVarArgs()
}

/**
 * Gets the maximum arity of any function that may be invoked at
 * call site `invk`.
 *
 * This is only defined if all potential callees have a fixed arity.
 */
int maxArity(CallSite invk) {
  forall (Function callee | callee = invk.getACallee() | isFixedArity(callee)) and
  result = max(invk.getACallee().getNumParameter())
}

/**
 * Holds if call site `invk` has more arguments than the maximum arity
 * of any function that it may invoke, and the first of those
 * arguments is `arg`.
 *
 * This predicate is only defined for call sites where callee information is complete.
 */
predicate firstSpuriousArgument(CallSite invk, Expr arg) {
  arg = invk.getArgumentNode(maxArity(invk)).asExpr() and
  not invk.isIncomplete()
}

/**
 * A list of spurious arguments passed at a call site.
 *
 * The list is represented by its first element (that is,
 * the first spurious argument), but `hasLocationInfo` is
 * defined to cover all subsequent arguments as well.
 */
class SpuriousArguments extends Expr {
  SpuriousArguments() {
    firstSpuriousArgument(_, this)
  }

  /**
   * Gets the call site at which the spurious arguments are passed.
   */
  CallSite getCall() {
    firstSpuriousArgument(result, this)
  }

  /**
   * Gets the number of spurious arguments, that is, the number of
   * actual arguments minus the maximum number of arguments
   * expected by any potential callee.
   */
  int getCount() {
    result = getCall().(InvokeExpr).getNumArgument() - maxArity(getCall())
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [LGTM locations](https://lgtm.com/help/ql/locations).
   */
  predicate hasLocationInfo(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    exists (Expr lastArg | lastArg = getCall().(InvokeExpr).getLastArgument() |
      lastArg.getLocation().hasLocationInfo(_, _, _, endline, endcolumn)
    )
  }
}

from SpuriousArguments args, Function f, string arguments
where f = args.getCall().getACallee() and
      if args.getCount() = 1 then arguments = "argument" else arguments = "arguments"
select args, "Superfluous " + arguments + " passed to $@.", f, f.describe()