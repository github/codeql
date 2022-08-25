import semmle.code.java.Expr

class SrcIntegerLiteral extends IntegerLiteral {
  SrcIntegerLiteral() { this.getCompilationUnit().fromSource() }
}

from SrcIntegerLiteral lit
select lit, lit.getValue(), lit.getIntValue()
