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

from
  Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Source sourceNode,
  Sink sinkNode
where
  cfg.hasFlowPath(source, sink) and
  sourceNode = source.getNode() and
  sinkNode = sink.getNode() and
  not sourceNode instanceof CleartextPasswordExpr // flagged by js/insufficient-password-hash
select sinkNode, source, sink, "$@ depends on $@.", sinkNode.getInitialization(),
  "A broken or weak cryptographic algorithm", sourceNode,
  "sensitive data from " + sourceNode.describe()
