/**
 * @kind path-problem
 */

import csharp
import Common
import TestUtilities.ProvenancePathGraph::ShowProvenance<Flow::PathNode, Flow::PathGraph>

from Flow::PathNode source, Flow::PathNode sink, string s
where
  Flow::flowPath(source, sink) and
  s = sink.toString()
select sink, source, sink, s order by s
