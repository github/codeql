/**
 * @name  Starting a process without a shell.
 * @description  Starting a process without a shell.
 *         https://bandit.readthedocs.io/en/latest/plugins/b606_start_process_with_no_shell.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/os-exec
 */

import python

predicate isObjectAttribute(Call c, string objectName, string methodName) {
  c.getFunc().(Attribute).getName().toString() = methodName
  and c.getFunc().(Attribute).getObject().toString() = objectName
}

from Call c
where (isObjectAttribute(c, "os", "execl")
   or isObjectAttribute(c, "os", "execle")
   or isObjectAttribute(c, "os", "execlp")
   or isObjectAttribute(c, "os", "execlpe")
   or isObjectAttribute(c, "os", "execv")
   or isObjectAttribute(c, "os", "execve")
   or isObjectAttribute(c, "os", "execvp")   
   or isObjectAttribute(c, "os", "execvpe")  

   or isObjectAttribute(c, "os", "spawnl")  
   or isObjectAttribute(c, "os", "spawnle")  
   or isObjectAttribute(c, "os", "spawnlp")  
   or isObjectAttribute(c, "os", "spawnlpe")  
   or isObjectAttribute(c, "os", "spawnv")  
   or isObjectAttribute(c, "os", "spawnve")  
   or isObjectAttribute(c, "os", "spawnvp")  
   or isObjectAttribute(c, "os", "spawnvpe")  
    
   or isObjectAttribute(c, "os", "startfile"))
  and exists(c.getLocation().getFile().getRelativePath())

select  c, "Starting a process without a shell."