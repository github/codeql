import csharp
import Common

class TTConfig extends TaintTracking::Configuration instanceof Config {
  override predicate isSource(DataFlow::Node source) { Config.super.isSource(source) }

  override predicate isSink(DataFlow::Node sink) { Config.super.isSink(sink) }
}

from TTConfig c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink
