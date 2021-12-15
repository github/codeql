import semmle.code.java.Expr

from NullLiteral lit
select lit, lit.getValue()
