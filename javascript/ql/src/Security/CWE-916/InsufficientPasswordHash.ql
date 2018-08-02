/**
 * @name Use of password hash with insufficient computational effort
 * @description Creating a hash of a password with low computational effort makes the hash vulnerable to password cracking attacks.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/insufficient-password-hash
 * @tags security
 *       external/cwe/cwe-916
 */
import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import semmle.javascript.security.dataflow.InsufficientPasswordHash::InsufficientPasswordHash

from Configuration cfg, Source source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "Password from $@ is hashed insecurely.", source , source.describe()
