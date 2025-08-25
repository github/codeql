/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rb/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import codeql.ruby.AST
import codeql.ruby.Concepts

from Cryptography::CryptographicOperation operation, string msgPrefix
where
  exists(Cryptography::CryptographicAlgorithm algorithm |
    algorithm = operation.getAlgorithm() and
    algorithm.isWeak() and
    msgPrefix = "The cryptographic algorithm " + algorithm.getName() and
    not algorithm instanceof Cryptography::HashingAlgorithm
  )
  or
  operation.getBlockMode().isWeak() and msgPrefix = "The block mode " + operation.getBlockMode()
select operation, "$@ is broken or weak, and should not be used.", operation.getInitialization(),
  msgPrefix
