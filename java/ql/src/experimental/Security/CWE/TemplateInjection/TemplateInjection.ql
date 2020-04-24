import java
import TemplateInjection::TemplateInjection
import semmle.code.java.dataflow.DataFlow

from TemplateInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source, sink
