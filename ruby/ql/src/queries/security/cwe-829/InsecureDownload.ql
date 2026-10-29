/**
 * @name Download of sensitive file through insecure connection
 * @description Downloading executables and other sensitive files over an insecure connection
 *              may allow man-in-the-middle attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.1
 * @precision high
 * @id rb/insecure-download
 * @tags security
 *       external/cwe/cwe-829
 */

import codeql.ruby.security.InsecureDownloadQuery
import InsecureDownloadFlow::PathGraph

from InsecureDownloadFlow::PathNode source, InsecureDownloadFlow::PathNode sink
where InsecureDownloadFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ of sensitive file from $@.",
  sink.getNode().(Sink).getDownloadCall(), "Download", source.getNode(), "HTTP source"
