/**
 * @name Request without certificate validation
 * @description Making a request without certificate validation can allow man-in-the-middle attacks.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id py/request-without-cert-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import python

import semmle.python.web.Http


FunctionObject requestFunction() {
    result = ModuleObject::named("requests").attr(httpVerbLower())
}

/** requests treats None as the default and all other "falsey" values as False */
predicate falseNotNone(Object o) {
    o.booleanValue() = false and not o = theNoneObject()
}

from CallNode call, FunctionObject func, Object falsey, ControlFlowNode origin
where 
func = requestFunction() and
func.getACall() = call and
falseNotNone(falsey) and
call.getArgByName("verify").refersTo(falsey, origin)

select call, "Call to $@ with verify=$@", func, "requests." + func.getName(), origin, "False"
