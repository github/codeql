private import cpp
private import semmle.code.cpp.ir.IR
private import PrintConfig

from Operand a
where shouldDumpLocation(a.getLocation())
select a, a.getDumpString()
