/**
 * @name Starting a process with a partial executable path
 * @description Starting a process with a partial executable path
 * 		https://bandit.readthedocs.io/en/latest/plugins/b607_start_process_with_partial_path.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/partial-path-process
 */

import python

from  Call c
where (c.getFunc().toString() = "pop" or c.getFunc().toString() = "popen")
  and (not c.getPositionalArg(0).(StrConst).getText().indexOf("/") >= 0
  	   and not c.getPositionalArg(0).(StrConst).getText().indexOf("\\") >= 0)
select c,"Starting a process with a partial executable path"