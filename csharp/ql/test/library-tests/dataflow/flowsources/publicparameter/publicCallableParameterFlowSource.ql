import semmle.code.csharp.dataflow.flowsources.PublicCallableParameter

from PublicCallableParameterFlowSource source
where source.getParameter().fromSource()
select source
