/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id go/weak-crypto-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import go
import semmle.go.security.BrokenCryptoAlgorithmQuery
import BrokenCryptoAlgorithmFlow::PathGraph

from BrokenCryptoAlgorithmFlow::PathNode source, BrokenCryptoAlgorithmFlow::PathNode sink
where BrokenCryptoAlgorithmFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ is used in a weak cryptographic algorithm.",
  source.getNode(), "Sensitive data"
