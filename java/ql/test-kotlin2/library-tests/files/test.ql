import java

from Parameter p
where p.fromSource()
select p, p.getType().toString(), p.getType().getFile().getBaseName(),
  p.getType().getLocation().getStartLine()
