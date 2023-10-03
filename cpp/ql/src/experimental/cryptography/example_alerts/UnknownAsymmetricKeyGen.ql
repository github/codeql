/**
 * @name Unknown key generation key size
 * @description
 * @id cpp/unknown-asymmetric-key-gen-size
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-326
 */

import cpp
import experimental.cryptography.Concepts

from AsymmetricKeyGeneration op, AsymmetricAlgorithm alg
where
  alg = op.getAlgorithm() and
  not alg instanceof EllipticCurveAlgorithm and
  not exists(op.getKeySizeInBits(alg))
select op, "Use of unknown asymmetric key size for algorithm $@", alg, alg.getName().toString()
