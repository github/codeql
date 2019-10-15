/**
 * @name  Deserialization with the marshal module is possibly dangerous.
 * @description Deserialization with the marshal module is possibly dangerous.
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b302-marshal
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision high
 * @id py/bandit/marshal-deserialize
 */

import python

predicate isMethodCall(Call c, string objectName, string methodName) {
  c.getFunc().(Attribute).getObject().toString() = objectName
  and c.getFunc().(Attribute).getName() = methodName
}

from Call c
where (isMethodCall(c, "marshal", "loads") 
   or isMethodCall(c, "marshal", "load"))
  and exists(c.getLocation().getFile().getRelativePath())
select c, "Deserialization with the marshal module is possibly dangerous."
