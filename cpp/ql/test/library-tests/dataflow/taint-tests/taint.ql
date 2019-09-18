import TaintTestCommon

from DataFlow::Node sink, DataFlow::Node source, TestAllocationConfig cfg
where cfg.hasFlow(source, sink)
select sink, source
