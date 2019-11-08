import go

from IR::Instruction u, Variable v
where u.reads(v)
select u, v
