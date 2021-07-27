/**
 * @name Android Intent redirect
 * @description xxx
 * @kind path-problem
 * @problem.severity error
 * @security-severity xx
 * @precision high
 * @id java/android/unsafe-android-webview-fetch
 * @tags security
 *       external/cwe/cwe-926
 *       external/cwe/cwe-940
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.AndroidIntentRedirectQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, IntentRedirectConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Arbitrary Android activities or services can be started from $@.", source.getNode(),
  "this user input"
