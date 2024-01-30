import cpp
import semmle.code.cpp.commons.StringConcatenation
import semmle.code.cpp.dataflow.new.DataFlow

from StringConcatenation s, Expr op, DataFlow::Node res
where
  s.getLocation().getFile().getBaseName() = "concat.cpp" and
  op = s.getAnOperand() and
  res = s.getResultNode()
select s, op, res
