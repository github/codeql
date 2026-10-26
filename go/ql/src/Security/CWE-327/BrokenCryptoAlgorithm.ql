/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id go/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import go

from Cryptography::CryptographicOperation operation, string msgPrefix, DataFlow::Node init
where
  init = operation.getInitialization() and
  // `init` may be a `BlockModeInit`, a `EncryptionAlgorithmInit`, or `operation` itself.
  (
    not init instanceof BlockModeInit and
    exists(Cryptography::CryptographicAlgorithm algorithm |
      algorithm = operation.getAlgorithm() and
      algorithm.isWeak() and
      msgPrefix = "The cryptographic algorithm " + algorithm.getName() and
      not algorithm instanceof Cryptography::HashingAlgorithm
    )
    or
    not init instanceof EncryptionAlgorithmInit and
    operation.getBlockMode().isWeak() and
    msgPrefix = "The block mode " + operation.getBlockMode()
  )
select operation, "$@ is broken or weak, and should not be used.", init, msgPrefix
