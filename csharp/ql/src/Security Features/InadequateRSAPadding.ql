/**
 * @name Weak encryption: inadequate RSA padding
 * @description Finds uses of RSA encryption with inadequate padding.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/inadequate-rsa-padding
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-780
 */

import csharp

from MethodCall mc, BoolLiteral b
where
  mc.getTarget().hasName("Encrypt") and
  mc
      .getTarget()
      .getDeclaringType()
      .hasQualifiedName("System.Security.Cryptography", "RSACryptoServiceProvider") and
  mc.getArgument(1) = b and
  b.getValue() = "false"
select b, "Enable RSA padding."
