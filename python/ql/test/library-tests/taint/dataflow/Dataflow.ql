import python
import Config

from TestConfiguration config, ControlFlowNode src, ControlFlowNode sink
where config.hasFlow(src, sink)
select src, sink
