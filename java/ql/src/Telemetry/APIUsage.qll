import java
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
  summaryModel(packageName(api), typeName(api), _, api.getName(), _, _, _, _, _)
}

predicate sink(Callable api) {
  sinkModel(packageName(api), typeName(api), _, api.getName(), _, _, _, _)
}

predicate source(Callable api) {
  sourceModel(packageName(api), typeName(api), _, api.getName(), _, _, _, _)
}

private string packageName(Callable api) {
  result = api.getCompilationUnit().getPackage().toString()
}

private string typeName(Callable api) {
  result = api.getDeclaringType().getAnAncestor().getSourceDeclaration().toString()
}
