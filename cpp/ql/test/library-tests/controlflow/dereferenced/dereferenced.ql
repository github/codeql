import cpp
import semmle.code.cpp.controlflow.Dereferenced

from Expr op, Expr e
where dereferencedByOperation(op, e) // => dereferenced(e)
select op, e
