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
int maxArity(DataFlow::InvokeNode invk) {
  forall(Function callee | callee = invk.getACallee() | isFixedArity(callee)) and
  result = max(invk.getACallee().getNumParameter())
}

/**
 * A list of spurious arguments passed at a call site.
 *
 * The list is represented by its first element (that is,
 * the first spurious argument), but `hasLocationInfo` is
 * defined to cover all subsequent arguments as well.
 */
class SpuriousArguments extends Expr {
  DataFlow::InvokeNode invk;

  SpuriousArguments() {
    this = invk.getArgument(maxArity(invk)).asExpr() and
    not invk.isIncomplete()
  }

  /**
   * Gets the call site at which the spurious arguments are passed.
   */
  DataFlow::InvokeNode getCall() { result = invk }

  /**
   * Gets the number of spurious arguments, that is, the number of
   * actual arguments minus the maximum number of arguments
   * expected by any potential callee.
   */
  int getCount() {
    result = count(int i | exists(invk.getArgument(i)) and i >= maxArity(getCall()))
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    exists(DataFlow::Node lastArg |
      lastArg = max(DataFlow::Node arg, int i | arg = invk.getArgument(i) | arg order by i)
    |
      lastArg.hasLocationInfo(_, _, _, endline, endcolumn)
    )
  }
}

from SpuriousArguments args, Function f, string arguments
where
  f = args.getCall().getACallee() and
  (if args.getCount() = 1 then arguments = "argument" else arguments = "arguments") and
  (
    // exclude empty functions, they are probably commented out debug utilities ...
    exists(f.getABodyStmt()) or
    // ... but include: constructors, arrows and externals/ambients
    f instanceof Constructor or // unlikely to be a debug utility
    f instanceof ArrowFunctionExpr or // cannot be empty
    f instanceof ExternalFunction or // always empty
    f.isAmbient() // always empty
  ) and
  not (
    // exclude no-param functions that trivially throw exceptions, they are probably placeholders
    f.getNumParameter() = 0 and
    f.getBodyStmt(0) instanceof ThrowStmt
  )
select args, "Superfluous " + arguments + " passed to $@.", f, f.describe()
