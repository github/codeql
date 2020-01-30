import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.ValueNumbering
import semmle.code.cpp.ir.IR

Expr ir(Expr e) {
  exists(Instruction i |
    e = i.getUnconvertedResultExpression() and
    result = valueNumber(i).getAnExpr()
  )
}

Expr ast(Expr e) { result = globalValueNumber(e).getAnExpr() }

from Expr e, Expr evn
where evn = ast(e) and not evn = ir(e)
select e, evn
