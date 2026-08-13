import codeql.ruby.DataFlow
import utils.test.InlineFlowTestUtil

from DataFlow::Node source, DataFlow::Node sink
where
  defaultSource(source) and
  defaultSink(sink) and
  source.getLocation().getFile().getBaseName() = "local_flow.rb" and
  DataFlow::localFlow(source, sink)
select source, sink
