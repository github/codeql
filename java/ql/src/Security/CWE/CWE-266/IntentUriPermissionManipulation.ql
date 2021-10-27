/**
 * @name Intent URI permission manipulation
 * @description When an externally provided Intent is returned to an Activity via setResult,
 *              a malicious application could use this to grant itself permissions to access
 *              arbitrary Content Providers that are accessible by the vulnerable application.
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
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink
where any(IntentUriPermissionManipulationConf c).hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This Intent can be set with arbitrary flags from $@, " +
    "and used to give access to internal Content Providers.", source.getNode(), "this user input"
