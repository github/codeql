import python

from StringPart s
select s.getLocation().getStartLine(), s.getText(), s.getLocation().getStartColumn(),
  s.getLocation().getEndColumn()
