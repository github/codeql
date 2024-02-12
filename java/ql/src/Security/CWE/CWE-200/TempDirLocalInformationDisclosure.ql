/**
 * @name Local information disclosure in a temporary directory
 * @description Writing information without explicit permissions to a shared temporary directory may disclose it to other users.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision medium
 * @id java/local-temp-file-or-directory-information-disclosure
 * @tags security
 *       external/cwe/cwe-200
 *       external/cwe/cwe-732
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.TempDirUtils
import semmle.code.java.security.TempDirLocalInformationDisclosureQuery

/**
 * We include use of inherently insecure methods, which don't have any associated
 * flow path, in with results describing a path from reading `java.io.tmpdir` or similar to use
 * in a file creation op.
 *
 * We achieve this by making inherently-insecure method invocations into an edge-less graph,
 * resulting in a zero-length paths.
 */
module InsecureMethodPathGraph implements DataFlow::PathGraphSig<MethodCallInsecureFileCreation> {
  predicate edges(
    MethodCallInsecureFileCreation n1, MethodCallInsecureFileCreation n2, string key, string value
  ) {
    none()
  }

  predicate nodes(MethodCallInsecureFileCreation n, string key, string val) {
    key = "semmle.label" and val = n.toString()
  }

  predicate subpaths(
    MethodCallInsecureFileCreation n1, MethodCallInsecureFileCreation n2,
    MethodCallInsecureFileCreation n3, MethodCallInsecureFileCreation n4
  ) {
    none()
  }
}

module Flow =
  DataFlow::MergePathGraph<TempDirSystemGetPropertyToCreate::PathNode,
    MethodCallInsecureFileCreation, TempDirSystemGetPropertyToCreate::PathGraph,
    InsecureMethodPathGraph>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, string message
where
  (
    TempDirSystemGetPropertyToCreate::flowPath(source.asPathNode1(), sink.asPathNode1()) and
    message =
      "Local information disclosure vulnerability from $@ due to use of file or directory readable by other local users."
    or
    source = sink and
    // Note this message has no "$@" placeholder, so the "system temp directory" template parameter below is not used.
    message =
      "Local information disclosure vulnerability due to use of " +
        source.asPathNode2().getFileSystemEntityType() + " readable by other local users."
  ) and
  not isPermissionsProtectedTempDirUse(sink.getNode())
select source.getNode(), source, sink, message, source.getNode(), "system temp directory"
