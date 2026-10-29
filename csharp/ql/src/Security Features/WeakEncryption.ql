/**
 * @name Weak encryption
 * @description Finds uses of encryption algorithms that are weak and obsolete
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cs/weak-encryption
 * @tags security
 *       external/cwe/cwe-327
 */

import csharp

predicate incorrectUseOfDES(ObjectCreation e, string msg) {
  e.getType()
      .(Class)
      .hasFullyQualifiedName("System.Security.Cryptography", "DESCryptoServiceProvider") and
  msg =
    "DES encryption uses keys of 56 bits only. Switch to AesCryptoServiceProvider or RijndaelManaged instead."
}

predicate incorrectUseOfTripleDES(ObjectCreation e, string msg) {
  e.getType()
      .(Class)
      .hasFullyQualifiedName("System.Security.Cryptography", "TripleDESCryptoServiceProvider") and
  msg =
    "TripleDES encryption provides at most 112 bits of security. Switch to AesCryptoServiceProvider or RijndaelManaged instead."
}

from Expr e, string msg
where
  incorrectUseOfDES(e, msg) or
  incorrectUseOfTripleDES(e, msg)
select e, msg
