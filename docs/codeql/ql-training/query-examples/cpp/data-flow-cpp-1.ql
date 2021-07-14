import cpp
import semmle.code.cpp.commons.Printf

from Call c, FormattingFunction ff, Expr format
where c.getTarget() = ff and
      format = c.getArgument(ff.getFormatParameterIndex()) and
      not format instanceof StringLiteral
select format, "Non-constant format string."