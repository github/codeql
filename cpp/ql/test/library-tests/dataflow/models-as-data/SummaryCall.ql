import testModels
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil

query predicate summaryCalls(SummaryCall c) { any() }

query predicate summarizedCallables(DataFlowCallable c) { c = TSummarizedCallable(_) }

query predicate sourceCallables(DataFlowCallable c) {
  c = TSourceCallable(_) and
  c.getLocation().getFile().toString() != ""
}
