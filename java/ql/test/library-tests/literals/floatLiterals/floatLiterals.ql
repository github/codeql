import semmle.code.java.Expr

class SrcFloatingPointLiteral extends FloatingPointLiteral {
  SrcFloatingPointLiteral() {
    this.getCompilationUnit().fromSource()
  }
}

from FloatingPointLiteral lit
select lit, lit.getValue(), lit.getFloatValue()
