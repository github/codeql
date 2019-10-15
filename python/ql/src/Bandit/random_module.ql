/**
 * @name Pseudo-random generators are not suitable for security
 * @description Standard pseudo-random generators are not suitable for security/cryptographic purposes.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b311-random
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/random-module
 */

import python

predicate isObjectAttribute(Expr e, string objectName, string methodName) {
  e.(Call).getFunc().(Attribute).getName().toString() = methodName
  and e.(Call).getFunc().(Attribute).getObject().toString() = objectName
}

from  Expr e
where isObjectAttribute(e, "random", "random")
   or isObjectAttribute(e, "random", "randrange")
   or isObjectAttribute(e, "random", "randint")
   or isObjectAttribute(e, "random", "choice")
   or isObjectAttribute(e, "random", "uniform")
   or isObjectAttribute(e, "random", "triangular")
   			 
select e, "Standard pseudo-random generators are not suitable for security/cryptographic purposes."