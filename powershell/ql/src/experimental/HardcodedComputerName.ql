/**
 * @name Hardcoded Computer Name
 * @description Do not hardcode computer names
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id powershell/microsoft/public/hardcoded-computer-name
 * @tags correctness
 *       security
 */

import powershell

from Argument a 
where a.getName() = "computername" and exists(a.getValue())
select a, "ComputerName argument is hardcoded to" + a.getValue()
