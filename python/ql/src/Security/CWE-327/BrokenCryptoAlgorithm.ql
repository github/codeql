/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
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
  // `Cryptography::HashingAlgorithm` and `Cryptography::PasswordHashingAlgorithm` are
  // handled by `py/weak-sensitive-data-hashing`
  algorithm instanceof Cryptography::EncryptionAlgorithm
select operation,
  "The cryptographic algorithm " + algorithm.getName() +
    " is broken or weak, and should not be used."
