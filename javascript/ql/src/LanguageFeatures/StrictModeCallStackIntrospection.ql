/**
 * @name Use of call stack introspection in strict mode
 * @description Accessing properties 'arguments.caller', 'arguments.callee',
 *              'Function.prototype.caller' or 'Function.prototype.arguments'
 *              in strict mode will cause a runtime error.
 * @kind problem
 * @problem.severity error
 * @id js/strict-mode-call-stack-introspection
 * @tags correctness
 *       language-features
 * @precision high
 */

import javascript

/**
 * Holds if it is illegal to access property `prop` on `baseVal` in strict-mode
 * code; `baseDesc` is a description of `baseVal` used in the alert message.
 */
predicate illegalPropAccess(AbstractValue baseVal, string baseDesc, string prop) {
  baseVal instanceof AbstractArguments and
  baseDesc = "arguments" and
  (prop = "caller" or prop = "callee")
  or
  baseVal instanceof AbstractFunction and
  baseDesc = "Function.prototype" and
  (prop = "caller" or prop = "arguments")
}

from PropAccess acc, DataFlow::AnalyzedNode baseNode, string base, string prop
where
  acc.accesses(baseNode.asExpr(), prop) and
  acc.getContainer().isStrict() and
  illegalPropAccess(baseNode.getAValue(), base, prop) and
  forex(AbstractValue av | av = baseNode.getAValue() | illegalPropAccess(av, _, prop)) and
  not acc = any(ExprStmt stmt).getExpr() // reported by js/useless-expression
select acc, "Strict mode code cannot use " + base + "." + prop + "."
