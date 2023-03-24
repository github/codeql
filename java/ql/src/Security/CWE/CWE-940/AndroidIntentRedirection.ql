/**
 * @name Android Intent redirection
 * @description Starting Android components with user-provided Intents
 *              can provide access to internal components of the application,
 *              increasing the attack surface and potentially causing unintended effects.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/android/intent-redirection
 * @tags security
 *       external/cwe/cwe-926
 *       external/cwe/cwe-940
 */

import java
import semmle.code.java.security.AndroidIntentRedirectionQuery
import IntentRedirectionFlow::PathGraph

from IntentRedirectionFlow::PathNode source, IntentRedirectionFlow::PathNode sink
where IntentRedirectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Arbitrary Android activities or services can be started from a $@.", source.getNode(),
  "user-provided value"
