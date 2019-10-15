/**
 * @name Requests call with verify=False
 * @description  Requests call with verify=False disabling SSL certificate checks, security issue.
 * 		 https://bandit.readthedocs.io/en/latest/plugins/b501_request_with_no_cert_validation.html
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/requests-ssl-verify-disabled
 */

import python

predicate isRequestsCallWithVefifyFalse(Expr e, string methodName) {
  e.(Call).getFunc().(Attribute).getName().toString() = methodName
  and e.(Call).getFunc().(Attribute).getObject().toString() = "requests"
  and exists(Keyword k | k = e.(Call).getANamedArg() 
  			and k.getArg() = "verify" 
  			and k.getValue().toString() = "False")
}

from  Expr e
where isRequestsCallWithVefifyFalse(e, "get")
   or isRequestsCallWithVefifyFalse(e, "post")
   or isRequestsCallWithVefifyFalse(e, "put")
   or isRequestsCallWithVefifyFalse(e, "delete")
   or isRequestsCallWithVefifyFalse(e, "patch")
   or isRequestsCallWithVefifyFalse(e, "options")
   or isRequestsCallWithVefifyFalse(e, "head")
    			 
select e, "Requests call with verify=False disabling SSL certificate checks, security issue."