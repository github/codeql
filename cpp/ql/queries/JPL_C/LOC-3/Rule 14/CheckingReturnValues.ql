/**
 * @name Unchecked return value
 * @description The return value of each non-void function call should be checked for error conditions, or cast to (void) if irrelevant.
 * @kind problem
 * @id cpp/jpl-c/checking-return-values
 * @problem.severity warning
 * @tags correctness
 *       reliability
 *       external/jpl
 */

import cpp

/**
 * In its full generality, the rule applies to all functions that
 * return non-void, including things like 'printf' and 'close',
 * which are routinely not checked because the behavior on success
 * is the same as the behavior on failure. The recommendation is
 * to add an explicit cast to void for such functions. For code
 * bases that have not been developed with this rule in mind, at
 * least for such commonly ignored functions, it may be better to
 * add them as exceptions to this whitelist predicate.
 */
predicate whitelist(Function f) {
  // Example:
  // f.hasName("printf") or f.hasName("close") or // ...
  none()
}

from FunctionCall c, string msg
where
  not c.getTarget().getType() instanceof VoidType and
  not whitelist(c.getTarget()) and
  (
    c instanceof ExprInVoidContext and
    msg = "The return value of non-void function $@ is not checked."
    or
    definition(_, c.getParent()) and
    not definitionUsePair(_, c.getParent(), _) and
    msg = "$@'s return value is stored but not checked."
  )
select c, msg, c.getTarget() as f, f.getName()
