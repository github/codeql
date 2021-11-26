import semmle.code.java.Expr

class SrcFloatingPointLiteral extends FloatLiteral {
  SrcFloatingPointLiteral() {
    this.getCompilationUnit().fromSource()
  }
}

from FloatLiteral lit
select lit, lit.getValue(), lit.getFloatValue()
