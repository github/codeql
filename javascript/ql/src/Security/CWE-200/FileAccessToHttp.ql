/**
 * @name File data in outbound network request
 * @description Directly sending file data in an outbound network request can indicate unauthorized information disclosure.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision medium
 * @id js/file-access-to-http
 * @tags security
 *       external/cwe/cwe-200
 */

import javascript
import semmle.javascript.security.dataflow.FileAccessToHttpQuery
import FileAccessToHttpFlow::PathGraph

from FileAccessToHttpFlow::PathNode source, FileAccessToHttpFlow::PathNode sink
where FileAccessToHttpFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Outbound network request depends on $@.", source.getNode(),
  "file data"
