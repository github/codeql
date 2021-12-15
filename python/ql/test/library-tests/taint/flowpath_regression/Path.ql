import python
import Config

from FooConfig config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select src.getSource(), sink.getSink()
