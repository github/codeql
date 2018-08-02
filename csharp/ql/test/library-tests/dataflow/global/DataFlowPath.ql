/**
 * @kind path-problem
 */
import csharp
import Common
import DataFlow::PathGraph

from Config c, DataFlow::PathNode source, DataFlow::PathNode sink, string s
where c.hasFlowPath(source, sink)
  and s = sink.toString()
select sink, s, source, sink
order by s asc
