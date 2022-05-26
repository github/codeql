import python
import Config

from TestConfiguration config, ControlFlowNode src, ControlFlowNode sink
where
  config
      .hasSimpleFlow(any(DataFlow::Node s | s.asCfgNode() = src),
        any(DataFlow::Node s | s.asCfgNode() = sink))
select src, sink
