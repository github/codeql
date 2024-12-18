import testModels
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate
private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil

query predicate summaryCalls(SummaryCall c) { any() }

query predicate summarizedCallables(SummarizedCallable c) { any() }

query predicate sourceCallables(SourceCallable c) { c.getLocation().getFile().toString() != "" }
