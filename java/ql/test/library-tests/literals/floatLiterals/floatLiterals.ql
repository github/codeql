import semmle.code.java.Expr

from FloatingPointLiteral lit
select lit, lit.getValue(), lit.getFloatValue()
