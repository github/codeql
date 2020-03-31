import javascript

from StringLiteral literal, RegExpDot dot, int pos
where
  dot.getParent*() = literal and
  pos = dot.getLocation().getStartColumn() - literal.getLocation().getStartColumn()
select dot, literal.getRawValue().charAt(pos)
