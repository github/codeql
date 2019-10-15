/**
 * @name Security implications associated with dill module.
 * @description Pickle and modules that wrap it can be unsafe when used to deserialize untrusted data, possible security issue.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b301-pickle
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/dill-load
 */

import python

predicate isMethodCall(Call c, string objectName, string methodName) {
  c.getFunc().(Attribute).getObject().toString() = objectName
  and c.getFunc().(Attribute).getName() = methodName
}

from Expr e
where isMethodCall(e, "dill", "loads")
or	  isMethodCall(e, "dill", "load")
select e, "Pickle and modules that wrap it can be unsafe when used to deserialize untrusted data, possible security issue."