import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumberingImpl as AST
import semmle.code.cpp.ir.internal.ASTValueNumbering as IR
import semmle.code.cpp.ir.IR

Expr ir(Expr e) { result = IR::globalValueNumber(e).getAnExpr() }

Expr ast(Expr e) { result = AST::globalValueNumber(e).getAnExpr() }

from Expr e, Expr evn, string note
where
  evn = ast(e) and not evn = ir(e) and note = "AST only"
  or
  evn = ir(e) and not evn = ast(e) and note = "IR only"
select e, evn, note
