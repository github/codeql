import cpp

from StringLiteral s
select s.getLocation().getStartLine(), s, s.getValueText()
