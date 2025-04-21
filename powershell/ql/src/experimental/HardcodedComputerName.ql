/**
 * @name Hardcoded Computer Name
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/microsoft/public/command-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import powershell

from Argument a 
where a.getName() = "computername" and exists(a.getValue())
select a, "ComputerName argument is hardcoded to" + a.getValue()
