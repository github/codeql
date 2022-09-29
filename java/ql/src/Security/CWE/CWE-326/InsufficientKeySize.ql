/**
 * @name Use of a cryptographic algorithm with insufficient key size
 * @description Using cryptographic algorithms with too small a key size can
 *              allow an attacker to compromise security.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.security.InsufficientKeySizeQuery

from Expr e, string msg
where
  hasShortAESKey(e, msg) or
  hasShortDsaKeyPair(e, msg) or
  hasShortRsaKeyPair(e, msg) or
  hasShortECKeyPair(e, msg)
select e, msg
