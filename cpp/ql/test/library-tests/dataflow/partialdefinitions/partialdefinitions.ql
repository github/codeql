import semmle.code.cpp.dataflow.internal.FlowVar

from PartialDefinition def
select def, def.getDefinedExpr(), def.getSubBasicBlockStart()
