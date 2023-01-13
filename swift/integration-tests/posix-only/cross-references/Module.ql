import swift

// check that the `cross_references` module has exactly one entity in the DB
from ModuleDecl m
where name = "cross_references"
select m
