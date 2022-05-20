import cpp

from Function f
select f, strictcount(f.getBlock()), count(f.getLocation())
