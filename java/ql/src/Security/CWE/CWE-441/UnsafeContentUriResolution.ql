/**
 * @name Uncontrolled data used in content resolution
 * @description Resolving externally-provided content URIs without validation can allow an attacker
 *              to access unexpected resources.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/android/unsafe-content-uri-resolution
 * @tags security
 *     external/cwe/cwe-441
 *     external/cwe/cwe-610
 */

import java
import semmle.code.java.security.UnsafeContentUriResolutionQuery
import UnsafeContentResolutionFlow::PathGraph

from UnsafeContentResolutionFlow::PathNode src, UnsafeContentResolutionFlow::PathNode sink
where UnsafeContentResolutionFlow::flowPath(src, sink)
select sink.getNode(), src, sink,
  "This ContentResolver method that resolves a URI depends on a $@.", src.getNode(),
  "user-provided value"
