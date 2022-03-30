import java

from Literal l
where
  l instanceof IntegerLiteral or
  l instanceof LongLiteral or
  l instanceof FloatingPointLiteral or
  l instanceof DoubleLiteral
select l, l.getValue(), l.getParent()
