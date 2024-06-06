/**
 * @name Unknown asymmetric key source generation
 * @description Finds all unknown potential sources for asymmetric key generation while using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/unkwon-asymmetric-key-generation
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from AsymmetricKeyGeneration op, CryptographicAlgorithm alg
where
  alg = op.getAlgorithm() and
  not op.hasKeyConfigurationSource(alg)
select op, "Key generator for algorithm $@ with unknown configuration source", alg, alg.getName()
