import cpp
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.ir.IR

// Every non-void instruction should have exactly one GVN.
// So this query should have zero results.
from Instruction i
where
  not i.getResultIRType() instanceof IRVoidType and
  count(valueNumber(i)) != 1
select i, concat(ValueNumber g | g = valueNumber(i) | g.getKind(), ", ")
