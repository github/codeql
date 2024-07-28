/**
 * @name Known asymmetric key source generation
 * @description Finds all known potential sources for asymmetric key generation while using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/asymmetric-key-generation
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from AsymmetricKeyGeneration op, CryptographicAlgorithm alg, Expr configSrc
where
  alg = op.getAlgorithm() and
  configSrc = op.getKeyConfigurationSource(alg)
select op, "Key generator for algorithm $@ with key configuration $@", alg, alg.getName(),
  configSrc, configSrc.toString()
