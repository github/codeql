/**
 * @kind path-problem
 */

import csharp
import Common
import DataFlow::PathGraph

class TTConfig extends TaintTracking::Configuration {
  Config c;

  TTConfig() { this = c }

  override predicate isSource(DataFlow::Node source) { c.isSource(source) }

  override predicate isSink(DataFlow::Node sink) { c.isSink(sink) }
}

from TTConfig c, DataFlow::PathNode source, DataFlow::PathNode sink, string s
where
  c.hasFlowPath(source, sink) and
  s = sink.toString()
select sink, source, sink, s
