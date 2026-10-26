/**
 * @name Intent URI permission manipulation
 * @description Returning an externally provided Intent via 'setResult' may allow a malicious
 *              application to access arbitrary content providers of the vulnerable application.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/android/intent-uri-permission-manipulation
 * @tags security
 *       external/cwe/cwe-266
 *       external/cwe/cwe-926
 */

import java
import semmle.code.java.security.IntentUriPermissionManipulationQuery
import semmle.code.java.dataflow.DataFlow
import IntentUriPermissionManipulationFlow::PathGraph

from
  IntentUriPermissionManipulationFlow::PathNode source,
  IntentUriPermissionManipulationFlow::PathNode sink
where IntentUriPermissionManipulationFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This Intent can be set with arbitrary flags from a $@, " +
    "and used to give access to internal content providers.", source.getNode(),
  "user-provided value"
