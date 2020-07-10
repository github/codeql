import python

class ImplicitConcat extends StrConst {
  ImplicitConcat() { exists(this.getAnImplicitlyConcatenatedPart()) }
}

from StrConst s, StringPart part, int n
where part = s.getImplicitlyConcatenatedPart(n)
select s.getLocation().getStartLine(), s.getText(), n, part.getText()
