/**
 * @name  Possible shell injection
 * @description Possible shell injection via Paramiko call, check inputs are properly sanitized.
 *          https://bandit.readthedocs.io/en/latest/plugins/b601_paramiko_calls.html
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision low
 * @id py/bandit/paramiko-injection
 */

import python

from  AssignStmt a, Call c
where a.getValue().(Call).getFunc().(Attribute).getName() = "SSHClient"
  and c.getFunc().(Attribute).getName() =  "exec_command"
         
select c, "Possible shell injection via Paramiko call, check inputs are properly sanitized."
