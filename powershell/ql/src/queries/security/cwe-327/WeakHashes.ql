/**
 * @name Use of weak cryptographic hash
 * @description Using weak cryptographic hash algorithms like MD5 or SHA1 can compromise data integrity and security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-hash
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.security.cryptography.Concepts

from HashAlgorithm hashAlg
where not hashAlg.getHashName() = ["sha256", "sha384", "sha512"]
select hashAlg, "Use of weak cryptographic hash algorithm: " + hashAlg.getHashName() + "."
