/**
 * @name Network data written to file
 * @description Writing network data directly to the file system allows arbitrary file upload and might indicate a backdoor.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.3
 * @precision medium
 * @id rb/http-to-file-access
 * @tags security
 *       external/cwe/cwe-912
 *       external/cwe/cwe-434
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.DataFlow::DataFlow::PathGraph
import codeql.ruby.security.HttpToFileAccessQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to file system", source.getNode(), "Untrusted data"
