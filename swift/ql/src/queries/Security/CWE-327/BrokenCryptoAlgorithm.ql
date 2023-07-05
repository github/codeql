/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import swift
import codeql.swift.Concepts

from Cryptography::CryptographicOperation operation, string msgPrefix
where
  // Hashing algorithms are handled by `swift/weak-sensitive-data-hashing`
  exists(Cryptography::EncryptionAlgorithm algorithm | algorithm = operation.getAlgorithm() |
    algorithm.isWeak() and
    msgPrefix = "The cryptographic algorithm " + operation.getAlgorithm().getName()
  )
  or
  operation.getBlockMode().isWeak() and msgPrefix = "The block mode " + operation.getBlockMode()
select operation, msgPrefix + " is broken or weak, and should not be used."
