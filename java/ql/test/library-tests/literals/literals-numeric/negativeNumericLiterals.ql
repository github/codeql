import java

class SrcLiteral extends Literal {
  SrcLiteral() { this.getCompilationUnit().fromSource() }
}

from SrcLiteral l
where
  l instanceof IntegerLiteral or
  l instanceof LongLiteral or
  l instanceof FloatLiteral or
  l instanceof DoubleLiteral
select l, l.getValue(), l.getParent()
