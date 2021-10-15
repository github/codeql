import cpp

from AggregateLiteral al
where al.getFile().getShortName() = "nested"
select al.getLocation().getStartLine()
