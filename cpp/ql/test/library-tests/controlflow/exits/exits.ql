import cpp

from Options opts, Function f, string status
where if opts.exits(f) then status = "exits" else status = "returns"
select f, f.getQualifiedName(), status
