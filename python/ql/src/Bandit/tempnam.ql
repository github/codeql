/**
 * @name Consider using tmpfile() 
 * @description Use of os.tempnam() and os.tmpnam() is vulnerable to symlink attacks. Consider using tmpfile() instead.
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b325-tempnam
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/tempnam
 */

import python

predicate isMethodCallOrAttribute(Call c, string methodName) {
  c.getFunc().(Attribute).getName().toString() = methodName
  or c.getFunc().toString() = methodName
}

from Call c
where isMethodCallOrAttribute(c, "tmpnam")
   or isMethodCallOrAttribute(c, "tempnam")
select c, "Use of os.tempnam() and os.tmpnam() is vulnerable to symlink attacks. Consider using tmpfile() instead."