import csharp
import Common

class TTConfig extends TaintTracking::Configuration {
  Config c;

  TTConfig() { this = c }

  override predicate isSource(DataFlow::Node source) { c.isSource(source) }

  override predicate isSink(DataFlow::Node sink) { c.isSink(sink) }
}

from TTConfig c, DataFlow::Node source, DataFlow::Node sink, string s
where
  c.hasFlow(source, sink) and
  s = sink.toString()
select s order by s
