import semmle.code.cpp.dataflow.internal.FlowVar

from Variable var, VariableAccess va
where FlowVar_internal::mayBeUsedUninitialized(var, va)
select var, va
