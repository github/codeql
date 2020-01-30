import cpp
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.ir.IR

// Unlike the AST global value numbering, which produces *exactly* 1 value number per expression,
// the IR global value numbering produces *at most* 1 value number per instruction.
from Instruction i
where count(valueNumber(i)) != 1
select i, concat(ValueNumber g | g = valueNumber(i) | g.getKind(), ", ")
