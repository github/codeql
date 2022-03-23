import java

from Variable v, int n
where
  n = count(v.getType()) and
  n != 1
select v, n
