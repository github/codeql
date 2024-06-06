/**
 * @name Known asymmetric key source generation
 * @description Finds all known potential sources for asymmetric key generation while using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/asymmetric-key-generation
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from AsymmetricKeyGen op, DataFlow::Node confSrc
where op.getKeyConfigSrc() = confSrc
select op,
  "Asymmetric key generation for algorithm " + op.getAlgorithm().getName() +
    " with key config source $@", confSrc, confSrc.toString()
