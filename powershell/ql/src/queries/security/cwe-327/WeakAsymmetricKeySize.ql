/**
 * @name Weak asymmetric key size
 * @description Using RSA keys smaller than 2048 bits does not provide adequate security.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-asymmetric-key-size
 * @tags security
 *       external/cwe/cwe-327
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.security.cryptography.Concepts

from AsymmetricKeyCreation keyCreation, int keySize
where
  keySize = keyCreation.getKeySize() and
  keySize < 2048
select keyCreation,
  "RSA key size " + keySize.toString() + " bits is below the minimum of 2048 bits."
