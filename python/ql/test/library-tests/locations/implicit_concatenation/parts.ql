import python

from StrConst s, StringPart part, int n
where part = s.getImplicitlyConcatenatedPart(n)
select s.getLocation().getStartLine(), s.getText(), n, part.getText()
