/**
 * @name Key Derivation Algorithms
 * @description Finds all potential usage of key derivation using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/key-derivation
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from KeyDerivationOperation op
// TODO: pull out all configuration from the operation?
select op,
  "Use of key derivation algorithm " + op.getAlgorithm().(KeyDerivationAlgorithm).getKDFName()
