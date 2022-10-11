import semmle.code.java.Expr

class SrcFloatingPointLiteral extends FloatLiteral {
  SrcFloatingPointLiteral() { this.getCompilationUnit().fromSource() }
}

from SrcFloatingPointLiteral lit
select lit, lit.getValue(), lit.getFloatValue()
