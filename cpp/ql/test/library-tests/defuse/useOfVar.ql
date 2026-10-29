import cpp

from StackVariable v, VariableAccess use
where useOfVar(v, use)
select v, use
