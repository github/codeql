import DataFlowConfig

from TestDataFlowConfiguration tttc, DataFlow::Node src, DataFlow::Node snk
where tttc.hasFlow(src, snk)
select src, snk
