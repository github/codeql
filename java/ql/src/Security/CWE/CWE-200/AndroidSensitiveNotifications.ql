/**
 * @name Exposure of sensitive information to notifications
 * @id java/android/sensitive-notification
 * @kind path-problem
 * @description Sensitive information exposed in a system notification can be read by an unauthorized application.
 * @problem.severity error
 * @precision medium
 * @security-severity 6.5
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import java
import semmle.code.java.security.SensitiveUiQuery
import NotificationTracking::PathGraph

from NotificationTracking::PathNode source, NotificationTracking::PathNode sink
where NotificationTracking::flowPath(source, sink)
select sink, source, sink, "This $@ is exposed in a system notification.", source,
  "sensitive information"
