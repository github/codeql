import cpp

from Variable v
select v, v.getType().explain(), v.getType().stripTopLevelSpecifiers().explain()
