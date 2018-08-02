import cpp

from LocalScopeVariable v, VariableAccess use
where useOfVarActual(v, use)
// Also check that `useOfVarActual` is a subset of `useOfVar`; if not
// the query will not return any results
and forall(LocalScopeVariable v0, VariableAccess use0 | useOfVarActual(v0, use0) | useOfVar(v0, use0))
select v, use