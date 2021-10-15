import python

class ImplicitConcat extends StrConst {
  ImplicitConcat() { exists(this.getAnImplicitlyConcatenatedPart()) }
}

from StringPart s
select s.getLocation().getStartLine(), s.getText(), s.getLocation().getStartColumn(),
  s.getLocation().getEndColumn()
