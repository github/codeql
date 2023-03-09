/**
 * @name Use of a broken or weak cryptographic algorithm on sensitive data
 * @description Using broken or weak cryptographic algorithms on sensitive data can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rb/sensitive-data-used-in-weak-crypto-operation
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import codeql.ruby.DataFlow
import codeql.ruby.security.SensitiveDataUsedInWeakCryptoOperationQuery
import codeql.ruby.security.SensitiveActions
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  not source.getNode() instanceof CleartextPasswordExpr // TODO: port js/insufficient-password-hash
select sink.getNode(), source, sink, "A broken or weak cryptographic algorithm depends on $@.",
  source.getNode(), "sensitive data from" + source.getNode().(Source).describe()
