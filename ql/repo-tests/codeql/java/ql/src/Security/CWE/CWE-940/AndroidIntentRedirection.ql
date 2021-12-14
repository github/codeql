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
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, IntentRedirectionConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Arbitrary Android activities or services can be started from $@.", source.getNode(),
  "this user input"
