import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

string supportKind(Callable api) {
  if api instanceof TaintPreservingCallable
  then result = "taint-preserving"
  else
    if summaryModel(packageName(api), typeName(api), _, api.getName(), _, _, _, _, _)
    then result = "summary"
    else
      if sinkModel(packageName(api), typeName(api), _, api.getName(), _, _, _, _)
      then result = "sink"
      else
        if sourceModel(packageName(api), typeName(api), _, api.getName(), _, _, _, _)
        then result = "source"
        else result = "?"
}

private string packageName(Callable api) {
  result = api.getCompilationUnit().getPackage().toString()
}

private string typeName(Callable api) {
  result = api.getDeclaringType().getAnAncestor().getSourceDeclaration().toString()
}
