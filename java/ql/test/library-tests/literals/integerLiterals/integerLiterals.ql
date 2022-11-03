import semmle.code.java.Expr

from IntegerLiteral lit
select lit, lit.getValue(), lit.getIntValue()
