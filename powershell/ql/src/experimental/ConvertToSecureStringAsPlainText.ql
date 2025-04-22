/**
 * @name Use of the AsPlainText parameter in ConvertTo-SecureString
 * @description Do not use the AsPlainText parameter in ConvertTo-SecureString
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id powershell/microsoft/public/convert-to-securestring-as-plaintext
 * @tags correctness
 *       security
 */

 import powershell

 from CmdCall c 
 where 
 c.getName() = "ConvertTo-SecureString" and
 c.hasNamedArgument("asplaintext")
 select c, "Use of AsPlainText parameter in ConvertTo-SecureString call"