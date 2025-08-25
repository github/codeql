/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.security.BrokenCryptoAlgorithmQuery
import InsecureCryptoFlow::PathGraph

from
  InsecureCryptoFlow::PathNode source, InsecureCryptoFlow::PathNode sink, CryptoAlgoSpec spec,
  BrokenAlgoLiteral algo, string reason
where
  sink.getNode().asExpr() = spec.getAlgoSpec() and
  source.getNode().asExpr() = algo and
  reason = getInsecureAlgorithmReason(algo.getValue()) and
  InsecureCryptoFlow::flowPath(source, sink)
select spec, source, sink, "Cryptographic algorithm $@ is insecure. " + reason, algo,
  algo.getValue()
