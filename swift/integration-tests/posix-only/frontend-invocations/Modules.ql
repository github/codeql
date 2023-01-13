import swift

from ModuleDecl m
where not m.getName().startsWith("_")
select m
