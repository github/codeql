/**
 * @name Hard-coded credential in API call
 * @description Using a hard-coded credential in a call to a sensitive Java API may compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision low
 * @id java/hardcoded-credential-api-call
 * @tags security
 *       external/cwe/cwe-798
 */

import semmle.code.java.security.HardcodedCredentialsApiCallQuery
import HardcodedCredentialApiCallFlow::PathGraph

from HardcodedCredentialApiCallFlow::PathNode source, HardcodedCredentialApiCallFlow::PathNode sink
where HardcodedCredentialApiCallFlow::flowPath(source, sink)
select source.getNode(), source, sink, "Hard-coded value flows to $@.", sink.getNode(),
  "sensitive API call"
