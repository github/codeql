/**
 * @name Possible wildcard injection
 * @description Possible wildcard injection in call
 *         https://bandit.readthedocs.io/en/latest/plugins/b609_linux_commands_wildcard_injection.html
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @id py/bandit/wildcard-injection
 */

import python

from Call c
where c.getPositionalArg(0).(StrConst).getText().regexpMatch("/bin.*\\*")
  and (
         c.getFunc().(Attribute).getName() = "system" 
         or c.getFunc().(Attribute).getName() = "popen2" 
         or 
          (c.getFunc().(Attribute).getName() = "Popen" 
           and exists(Keyword k | k = c.getANamedArg() 
              and k.getArg() = "shell"
              and k.getValue().toString() = "True")           
          )
         )
select c, "Possible wildcard injection in call: " + c.getFunc().(Attribute).getName()
