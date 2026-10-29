/**
 * @name Partial path traversal vulnerability from remote
 * @description A prefix used to check that a canonicalised path falls within another must be slash-terminated.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/partial-path-traversal-from-remote
 * @tags security
 *       external/cwe/cwe-023
 */

import semmle.code.java.security.PartialPathTraversalQuery
import PartialPathTraversalFromRemoteFlow::PathGraph

from
  PartialPathTraversalFromRemoteFlow::PathNode source,
  PartialPathTraversalFromRemoteFlow::PathNode sink
where PartialPathTraversalFromRemoteFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Partial Path Traversal Vulnerability due to insufficient guard against path traversal from $@.",
  source, "user-supplied data"
