/**
 * @name Weak key generation key size (< 2048 bits)
 * @description
 * @id py/weak-asymmetric-key-gen-size
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-326
 */

import python
import experimental.cryptography.Concepts

from AsymmetricKeyGen op, DataFlow::Node configSrc, int keySize, string algName
where
  keySize = op.getKeySizeInBits(configSrc) and
  keySize < 2048 and
  algName = op.getAlgorithm().getName() and
  // Can't be an elliptic curve
  not isEllipticCurveAlgorithm(algName, _)
select op,
  "Use of weak asymmetric key size (int bits)" + keySize.toString() + " for algorithm " +
    algName.toString() + " at config source $@", configSrc, configSrc.toString()
