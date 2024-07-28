/**
 * @name Weak asymmetric key generation key size (< 2048 bits)
 * @description
 * @id cpp/weak-asymmetric-key-gen-size
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-326
 */

import cpp
import experimental.cryptography.Concepts

from AsymmetricKeyGeneration op, AsymmetricAlgorithm alg, Expr configSrc, int size
where
  alg = op.getAlgorithm() and
  not alg instanceof EllipticCurveAlgorithm and
  configSrc = op.getKeyConfigurationSource(alg) and
  size = configSrc.getValue().toInt() and
  size < 2048
select op,
  "Use of weak asymmetric key size (in bits) " + size + " configured at $@ for algorithm $@",
  configSrc, configSrc.toString(), alg, alg.getName().toString()
