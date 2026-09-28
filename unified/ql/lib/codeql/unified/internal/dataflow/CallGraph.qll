private import unified
private import AllDataFlow
private import codeql.unified.internal.typeinference.TypeInference as T

DataFlowCallable viableCallable(DataFlowCall c) {
  result.asSourceCallable() = T::resolveCallTarget(c.asExplicitCall())
}
