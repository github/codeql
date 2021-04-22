/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import semmle.python.Concepts

from Cryptography::CryptographicOperation operation, Cryptography::CryptographicAlgorithm algorithm
where
  algorithm = operation.getAlgorithm() and
  algorithm.isWeak() and
  not algorithm instanceof Cryptography::HashingAlgorithm and // handled by `py/weak-sensitive-data-hashing`
  not algorithm instanceof Cryptography::PasswordHashingAlgorithm // handled by `py/weak-sensitive-data-hashing`
select operation,
  "The cryptographic algorithm " + algorithm.getName() +
    " is broken or weak, and should not be used."
