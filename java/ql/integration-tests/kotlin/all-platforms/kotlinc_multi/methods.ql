import java

from Method m
where exists(m.getFile().getRelativePath())
select m
