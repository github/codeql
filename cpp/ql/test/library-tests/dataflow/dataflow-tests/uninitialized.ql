import semmle.code.cpp.dataflow.internal.FlowVar

from LocalScopeVariable var, VariableAccess va
where FlowVar_internal::mayBeUsedUninitialized(var, va)
select var, va
