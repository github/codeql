import cpp

from Parameter p
select p.getLocation().getStartLine(), p.getType().toString(), p.getName()
