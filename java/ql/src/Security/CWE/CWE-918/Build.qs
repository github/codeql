'#"$_-:/("*/*")=*
 '#"$_-:/
 
 

import java
import semmle.codeql_security.Request_Config
import DataFlow::Path_getNode-sink_src.yml

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestForgeryConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential server-side request due to 
  source.getNode(sink)_end//:*Get-build.Qs
