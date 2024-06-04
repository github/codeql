/**
 * @name Use of a potentially broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/potentially-weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Properties
import semmle.code.java.security.MaybeBrokenCryptoAlgorithmQuery
import InsecureCryptoFlow::PathGraph

from InsecureCryptoFlow::PathNode source, InsecureCryptoFlow::PathNode sink, CryptoAlgoSpec c
where
  sink.getNode().asExpr() = c.getAlgoSpec() and
  InsecureCryptoFlow::flowPath(source, sink)
select c, source, sink,
  "Cryptographic algorithm $@ may not be secure, consider using a different algorithm.", source,
  source.getNode().asExpr().(InsecureAlgorithm).getStringValue()
