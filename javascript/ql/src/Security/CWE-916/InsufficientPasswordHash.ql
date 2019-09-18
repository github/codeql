/**
 * @name Use of password hash with insufficient computational effort
 * @description Creating a hash of a password with low computational effort makes the hash vulnerable to password cracking attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/insufficient-password-hash
 * @tags security
 *       external/cwe/cwe-916
 */

import javascript
import semmle.javascript.security.dataflow.InsufficientPasswordHash::InsufficientPasswordHash
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Password from $@ is hashed insecurely.", source.getNode(),
  source.getNode().(Source).describe()
