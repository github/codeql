/**
 * @name Use of implicit PendingIntents
 * @description Sending an implicit and mutable 'PendingIntent' to an unspecified third party
 *              component may provide an attacker with access to internal components of the
 *              application or cause other unintended effects.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.2
 * @precision high
 * @id java/android/implicit-pendingintents
 * @tags security
 *       external/cwe/cwe-927
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ImplicitPendingIntentsQuery
import ImplicitPendingIntentStartFlow::PathGraph

from ImplicitPendingIntentStartFlow::PathNode source, ImplicitPendingIntentStartFlow::PathNode sink
where ImplicitPendingIntentStartFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ and sent to an unspecified third party through a PendingIntent.", source.getNode(),
  "An implicit Intent is created"
