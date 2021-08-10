import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.FlowSources

string supportKind(Callable api) {
  if api instanceof TaintPreservingCallable
  then result = "taint-preserving"
  else
    if summaryCall(api)
    then result = "summary"
    else
      if sink(api)
      then result = "sink"
      else
        if source(api)
        then result = "source"
        else result = "?"
}

predicate summaryCall(Callable api) {
  api instanceof SummarizedCallable
  or
  exists(Call call, DataFlow::Node arg |
    call.getCallee() = api and
    [call.getAnArgument(), call.getQualifier()] = arg.asExpr() and
    TaintTracking::localAdditionalTaintStep(arg, _)
  )
}

predicate sink(Callable api) {
  exists(Call call, DataFlow::Node arg |
    call.getCallee() = api and
    [call.getAnArgument(), call.getQualifier()] = arg.asExpr() and
    sinkNode(arg, _)
  )
}

predicate source(Callable api) {
  exists(Call call, DataFlow::Node arg |
    call.getCallee() = api and
    [call.getAnArgument(), call.getQualifier()] = arg.asExpr() and
    arg instanceof RemoteFlowSource
  )
}
