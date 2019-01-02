/**
 * @name Encryption using ECB
 * @description Highlights uses of the encryption mode 'CipherMode.ECB'. This mode should normally not be used because it is vulnerable to replay attacks.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/ecb-encryption
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp

from FieldAccess a, Field ecb, Enum e
where
  a.getTarget() = ecb and
  ecb.hasName("ECB") and
  ecb.getDeclaringType() = e and
  e.hasQualifiedName("System.Security.Cryptography", "CipherMode")
select a, "The ECB (Electronic Code Book) encryption mode is vulnerable to replay attacks."
