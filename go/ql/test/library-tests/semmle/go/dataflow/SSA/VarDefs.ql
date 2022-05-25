import go

from IR::Instruction d, Variable v, ControlFlow::Node rhs
where d.writes(v, rhs)
select d, v, rhs
