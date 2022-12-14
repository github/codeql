/**
 * @name Insecure temporary file
 * @description Creating a temporary file that is accessible by other users can
 * lead to information disclosure and sometimes remote code execution.
 * @kind path-problem
 * @id js/insecure-temporary-file
 * @problem.severity warning
 * @security-severity 7.0
 * @precision medium
 * @tags external/cwe/cwe-377
 *       external/cwe/cwe-378
 *       security
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.InsecureTemporaryFileQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure creation of file in $@.", source.getNode(),
  "the os temp dir"
