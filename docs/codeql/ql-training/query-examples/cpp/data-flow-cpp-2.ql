import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.commons.Printf

class SourceNode extends DataFlow::Node { /* ... */ }

from FormattingFunction f, Call c, SourceNode src, DataFlow::Node arg
where c.getTarget() = f and
      arg.asExpr() = c.getArgument(f.getFormatParameterIndex()) and
      DataFlow::localFlow(src, arg) and
      not src.asExpr() instanceof StringLiteral
select arg, "Non-constant format string."
