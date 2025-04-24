/**
 * @name Use of Invoke-Expression
 * @description Do not use Invoke-Expression
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/microsoft/public/do-not-use-invoke-expression
 * @tags security
 */
import powershell
import semmle.code.powershell.dataflow.DataFlow

from CmdCall call 
where call.matchesName("Invoke-Expression")
select call, "Do not use Invoke-Expression. It is a command injection risk."
