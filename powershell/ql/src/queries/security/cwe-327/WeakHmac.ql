/**
 * @name Use of weak HMAC algorithm
 * @description Using weak HMAC algorithms like HMACMD5 or HMACSHA1 can compromise message authentication.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-hmac
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.security.cryptography.Concepts

from HmacAlgorithm hmacAlg
where not hmacAlg.getHmacName() = ["hmacsha256", "hmacsha384", "hmacsha512"]
select hmacAlg, "Use of weak HMAC algorithm: " + hmacAlg.getHmacName() + ". Use HMACSHA256 or stronger."
