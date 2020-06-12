/**
 * @name Download of sensitive file through unsecure connection
 * @description Downloading executeables and other sensitive files over an unsecure connection
 *              opens up for potential man-in-the-middle attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/unsecure-download
 * @tags security
 *       external/cwe/cwe-829
 */

import javascript
import semmle.javascript.security.dataflow.UnsecureDownload::UnsecureDownload
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ of sensitive file from $@.",
  sink.getNode().(Sink).getDownloadCall(), "Download", source.getNode(), "HTTP source"
