import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.commons.Printf

from FormattingFunction format, FunctionCall call, Expr formatString, DataFlow::Node sink
where
  call.getTarget() = format and
  call.getArgument(format.getFormatParameterIndex()) = formatString and
  sink.asIndirectExpr(1) = formatString and
  not exists(DataFlow::Node source |
    DataFlow::localFlow(source, sink) and
    source.asIndirectExpr(1) instanceof StringLiteral
  )
select call, "Argument to " + format.getQualifiedName() + " isn't hard-coded."
