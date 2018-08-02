import cpp

from LocalScopeVariable v, VariableAccess use
where useOfVar(v, use)
select v, use
