/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import javascript
import semmle.javascript.security.dataflow.BrokenCryptoAlgorithm::BrokenCryptoAlgorithm
import semmle.javascript.security.SensitiveActions

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink) and
      not source.asExpr() instanceof CleartextPasswordExpr // flagged by js/insufficient-password-hash
select sink, "Sensitive data from $@ is used in a broken or weak cryptographic algorithm.", source , source.(Source).describe()
