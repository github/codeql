/**
 * @name Pickle and modules that wrap it can be unsafe
 * @description Pickle and modules that wrap it can be unsafe when used to deserialize untrusted data, possible security issue.
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b301-pickle
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision high
 * @id py/bandit/pickle-deserialize
 */

import python

predicate isObjectAttribute(Expr e, string objectName, string methodName) {
  e.(Call).getFunc().(Attribute).getName().toString() = methodName
  and e.(Call).getFunc().(Attribute).getObject().toString() = objectName
}

from  Expr e
where (isObjectAttribute(e, "pickle", "dumps")
   or isObjectAttribute(e, "pickle", "load")
   or isObjectAttribute(e, "cPickle", "loads")
   or e.(Attribute).getName() = "Unpickler" 
           and (e.(Attribute).getObject().toString() = "pickle" 
                or e.(Attribute).getObject().toString() = "cPickle"))

  and exists(e.getLocation().getFile().getRelativePath())
                
select e, "Pickle and modules that wrap it can be unsafe when used to deserialize untrusted data, possible security issue."