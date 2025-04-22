/**
 * @name Use of Username or Password parameter
 * @description Do not use username or password parameters
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id powershell/microsoft/public/username-or-password-parameter
 * @tags correctness
 *       security
 */

 import powershell

from Parameter p
where p.getName().toLowerCase() = ["username", "password"]
select p, "Do not use username or password parameters."
