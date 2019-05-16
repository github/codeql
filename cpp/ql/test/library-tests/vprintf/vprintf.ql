import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.commons.Printf

from FormattingFunctionCall call, Expr formatString
where
  call.getArgument(call.getFormatParameterIndex()) = formatString
  and not call.getTarget() instanceof UserDefinedFormattingFunction
select call, "Format string " + formatString.toString() + " passed to "  + call.getTarget().getName()
