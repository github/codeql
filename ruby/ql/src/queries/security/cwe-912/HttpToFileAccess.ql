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

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.security.HttpToFileAccessQuery
import HttpToFileAccessFlow::PathGraph

from HttpToFileAccessFlow::PathNode source, HttpToFileAccessFlow::PathNode sink
where HttpToFileAccessFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Write to file system depends on $@.", source.getNode(),
  "untrusted data"
