/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-symmetric-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.security.cryptography.Concepts

from SymmetricAlgorithm symmetricAlg
where not symmetricAlg.getSymmetricAlgorithmName() = ["aes", "aes128", "aes192", "aes256"]
select symmetricAlg,
  "Use of weak symmetric cryptographic algorithm: " + symmetricAlg.getSymmetricAlgorithmName() +
    ". Consider using AES instead."
