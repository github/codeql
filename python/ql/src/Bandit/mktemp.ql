/**
 * @name Use of insecure and deprecated function (mktemp).
 * @description Use of insecure and deprecated function (mktemp).
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b306-mktemp-q
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision medium
 * @id py/bandit/mktemp
 */

import python

predicate isMethodCallOrAttribute(Call c, string methodName) {
  c.getFunc().(Attribute).getName().toString() = methodName
  or c.getFunc().toString() = methodName
}

from Call c
where isMethodCallOrAttribute(c, "mktemp")
  and exists(c.getLocation().getFile().getRelativePath())
select c, "Use of insecure and deprecated function (mktemp)."