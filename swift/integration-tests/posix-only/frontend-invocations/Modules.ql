import swift

from ModuleDecl m
where m.getName().charAt(0) != "_"
select m
