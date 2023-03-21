/**
 * @kind path-problem
 */

import csharp
import Common
import DataFlow::PathGraph

class TTConfig extends TaintTracking::Configuration instanceof Config {
  override predicate isSource(DataFlow::Node source) { Config.super.isSource(source) }

  override predicate isSink(DataFlow::Node sink) { Config.super.isSink(sink) }
}

from TTConfig c, DataFlow::PathNode source, DataFlow::PathNode sink, string s
where
  c.hasFlowPath(source, sink) and
  s = sink.toString()
select sink, source, sink, s
