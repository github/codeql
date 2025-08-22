/**
 * @name Hash Algorithms
 * @description Finds all potential usage of cryptographic hash algorithms using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/classic-model/hash-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import semmle.python.Concepts

from Cryptography::CryptographicOperation operation, Cryptography::CryptographicAlgorithm algorithm
where
  algorithm = operation.getAlgorithm() and
  (
    algorithm instanceof Cryptography::HashingAlgorithm or
    algorithm instanceof Cryptography::PasswordHashingAlgorithm
  )
select operation, "Use of algorithm " + operation.getAlgorithm().getName()
