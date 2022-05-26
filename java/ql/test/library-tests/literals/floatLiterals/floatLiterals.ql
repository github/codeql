import semmle.code.java.Expr

from FloatLiteral lit
select lit, lit.getValue(), lit.getFloatValue()
