/**
 * @name Hard-coded credential in sensitive call
 * @description Using a hard-coded credential in a sensitive call may compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision low
 * @id java/hardcoded-credential-sensitive-call
 * @tags security
 *       external/cwe/cwe-798
 */

import java
import semmle.code.java.security.HardcodedCredentialsSourceCallQuery
import HardcodedCredentialSourceCallFlow::PathGraph

from
  HardcodedCredentialSourceCallFlow::PathNode source,
  HardcodedCredentialSourceCallFlow::PathNode sink
where HardcodedCredentialSourceCallFlow::flowPath(source, sink)
select source.getNode(), source, sink, "Hard-coded value flows to $@.", sink.getNode(),
  "sensitive call"
