import cpp
import semmle.code.cpp.dataflow.StackAddress

from FunctionCall call, Expr use, Type useType, Expr source, boolean isLocal
where
  use = call.getAnArgument() and
  stackPointerFlowsToUse(use, useType, source, isLocal)
select use, useType, source, isLocal
