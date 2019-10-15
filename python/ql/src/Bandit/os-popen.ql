/**
 * @name  Starting a process without a shell.
 * @description  Starting a process without a shell.
 * 		https://bandit.readthedocs.io/en/latest/plugins/b606_start_process_with_no_shell.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/os-popen
 */

import python

predicate isMethodCallOrAttribute(Call c, string methodName) {
  c.getFunc().(Attribute).getName().toString() = methodName
  or c.getFunc().toString() = methodName
}

predicate isObjectAttribute(Call c, string objectName, string methodName) {
  c.getFunc().(Attribute).getName().toString() = methodName
  and c.getFunc().(Attribute).getObject().toString() = objectName
}

from Call c
where (isMethodCallOrAttribute(c, "popen")
   or isMethodCallOrAttribute(c, "popen2")
   or isMethodCallOrAttribute(c, "popen3")
   or isMethodCallOrAttribute(c, "popen4")

   or isObjectAttribute(c, "commands", "getstatusoutput")  
   or isObjectAttribute(c, "commands", "getoutput")  
   
   or isObjectAttribute(c, "popen2", "popen2")  
   or isObjectAttribute(c, "popen2", "popen3")  
   or isObjectAttribute(c, "popen2", "popen4")  
   or isObjectAttribute(c, "popen2", "Popen3")  
   or isObjectAttribute(c, "popen2", "Popen4"))
  and exists(c.getLocation().getFile().getRelativePath())

select  c, "Starting a process with a shell: Seems safe, but may be changed in the future, consider rewriting without shell"