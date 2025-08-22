import swift

// check that the `cross_references` module has exactly one entity in the DB
from ModuleDecl m
where m.getName() = "cross_references"
select m
