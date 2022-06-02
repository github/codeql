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

import ruby
import codeql.ruby.Concepts

from Cryptography::CryptographicOperation operation
where operation.isWeak()
select operation,
  "The cryptographic algorithm " + operation.getAlgorithm().getName() +
    " is broken or weak, and should not be used."
