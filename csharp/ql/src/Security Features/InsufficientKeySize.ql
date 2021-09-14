/**
 * @name Weak encryption: Insufficient key size
 * @description Finds uses of encryption algorithms with too small a key size
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cs/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import csharp

predicate incorrectUseOfRC2(Assignment e, string msg) {
  exists(PropertyAccess pa |
    pa.getParent() = e and
    pa.getTarget().hasName("EffectiveKeySize") and
    pa.getTarget()
        .getDeclaringType()
        .hasQualifiedName("System.Security.Cryptography", "RC2CryptoServiceProvider")
  ) and
  e.getRValue().getValue().toInt() < 128 and
  msg = "Key size should be at least 128 bits for RC2 encryption."
}

predicate incorrectUseOfDSA(ObjectCreation e, string msg) {
  e.getTarget()
      .getDeclaringType()
      .hasQualifiedName("System.Security.Cryptography", "DSACryptoServiceProvider") and
  exists(Expr i | e.getArgument(0) = i and i.getValue().toInt() < 2048) and
  msg = "Key size should be at least 2048 bits for DSA encryption."
}

predicate incorrectUseOfRSA(ObjectCreation e, string msg) {
  e.getTarget()
      .getDeclaringType()
      .hasQualifiedName("System.Security.Cryptography", "RSACryptoServiceProvider") and
  exists(Expr i | e.getArgument(0) = i and i.getValue().toInt() < 2048) and
  msg = "Key size should be at least 2048 bits for RSA encryption."
}

from Expr e, string msg
where
  incorrectUseOfRC2(e, msg) or
  incorrectUseOfDSA(e, msg) or
  incorrectUseOfRSA(e, msg)
select e, msg
