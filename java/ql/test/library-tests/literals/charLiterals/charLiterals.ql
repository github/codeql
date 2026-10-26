import semmle.code.java.Expr

from CharacterLiteral lit
select lit, lit.getValue(), lit.getCodePointValue()
