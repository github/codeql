/**
 * @name Exposure of sensitive information to UI text views
 * @id java/android/sensitive-text
 * @kind path-problem
 * @description Sensitive information displayed in UI text views should be properly masked.
 * @problem.severity warning
 * @precision medium
 * @security-severity 6.5
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import java
import semmle.code.java.security.SensitiveUiQuery
import TextFieldTracking::PathGraph

from TextFieldTracking::PathNode source, TextFieldTracking::PathNode sink
where TextFieldTracking::flowPath(source, sink)
select sink, source, sink, "This $@ is exposed in a text view.", source, "sensitive information"
