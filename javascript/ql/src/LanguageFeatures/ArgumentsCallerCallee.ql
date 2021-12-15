/**
 * @name Use of arguments.caller or arguments.callee
 * @description The properties 'arguments.caller' and 'argument.callee' have subtle semantics and
 *              make code non-modular and hard to maintain. Consequently, they should not be used.
 * @kind problem
 * @problem.severity recommendation
 * @id js/call-stack-introspection
 * @tags maintainability
 *       language-features
 * @precision medium
 */

import javascript

from PropAccess acc, ArgumentsVariable args
where
  acc.getBase() = args.getAnAccess() and
  acc.getPropertyName().regexpMatch("caller|callee") and
  // don't flag cases where the variable can never contain an arguments object
  not exists(Function fn | args = fn.getVariable()) and
  not exists(Parameter p | args = p.getAVariable()) and
  // arguments.caller/callee in strict mode causes runtime errors,
  // this is covered by the query 'Use of call stack introspection in strict mode'
  not acc.getContainer().isStrict()
select acc, "Avoid using arguments.caller and arguments.callee."
