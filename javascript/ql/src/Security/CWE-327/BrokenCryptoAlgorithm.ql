/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import javascript
import semmle.javascript.security.dataflow.BrokenCryptoAlgorithmQuery
import semmle.javascript.security.SensitiveActions
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  not source.getNode() instanceof CleartextPasswordExpr // flagged by js/insufficient-password-hash
select sink.getNode(), source, sink, "A broken or weak cryptographic algorithm depends on $@.",
  source.getNode(), "sensitive data from" + source.getNode().(Source).describe()
