/**
 * @name Request Without Certificate Validation
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
    exists(ModuleObject req |
        req.getName() = "requests" and
        result = req.getAttribute(httpVerbLower())
    )
}

from CallNode call, FunctionObject func, ControlFlowNode false_
where 
func = requestFunction() and
func.getACall() = call and
call.getArgByName("verify").refersTo(theFalseObject(), false_)

select call, "Call to $@ with verify=$@", func, "requests." + func.getName(), false_, "False"
