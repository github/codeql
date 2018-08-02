import cpp

from Assignment a
select a,
       a.getLValue() as l,
       l.getType().explain(),
       a.getRValue() as r,
       r.getType().explain()

