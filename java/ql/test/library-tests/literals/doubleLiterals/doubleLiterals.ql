import semmle.code.java.Expr

from DoubleLiteral lit
select lit, lit.getValue(), lit.getDoubleValue()
