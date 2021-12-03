import semmle.code.cpp.dataflow.internal.FlowVar

from PartialDefinition def
select def.getActualLocation().toString(), "partial def of " + def.toString(), def,
  def.getSubBasicBlockStart()
