import java

from ClassOrInterface c
where c.fromSource()
select c, c.getAPermittedSubtype()
