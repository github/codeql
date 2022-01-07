import semmle.code.java.Expr

from BooleanLiteral lit
where lit.getCompilationUnit().fromSource()
select lit, lit.getValue(), lit.getBooleanValue()
