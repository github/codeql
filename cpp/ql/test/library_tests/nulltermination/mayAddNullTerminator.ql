import cpp
import semmle.code.cpp.commons.NullTermination

from Expr e, VariableAccess va
where mayAddNullTerminator(e, va)
select e, va
