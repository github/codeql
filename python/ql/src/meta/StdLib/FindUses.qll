private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.internal.FlowSummaryImpl as FlowSummaryImpl

pragma[inline]
predicate inStdLib(DataFlow::Node node) { node.getLocation().getFile().inStdlib() }

pragma[inline]
string stepsTo(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  if
    DataFlow::localFlow(nodeFrom, nodeTo)
    or
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
    or
    nodeFrom = nodeTo.(DataFlow::PostUpdateNode).getPreUpdateNode()
  then result = "value"
  else
    if
      TaintTracking::localTaint(nodeFrom, nodeTo)
      or
      exists(TaintTracking::AdditionalTaintStep s | s.step(nodeFrom, nodeTo))
      or
      FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(nodeFrom, nodeTo, _)
    then result = "taint"
    else result = "no"
}

string computeScopePath(Scope scope) {
  // base case
  if scope instanceof Module
  then
    scope.(Module).isPackageInit() and
    result = scope.(Module).getPackageName()
    or
    not scope.(Module).isPackageInit() and
    result = scope.(Module).getName()
  else
    //recursive cases
    if scope instanceof Class
    then
      result = computeScopePath(scope.(Class).getEnclosingScope()) + "." + scope.(Class).getName()
    else
      if scope instanceof Function
      then
        result =
          computeScopePath(scope.(Function).getEnclosingScope()) + "." + scope.(Function).getName()
      else result = "unknown: " + scope.toString()
}

string computeFunctionName(Function function) { result = computeScopePath(function) }

bindingset[fullyQualified]
predicate fullyQualifiedToYamlFormat(string fullyQualified, string type2, string path) {
  exists(int firstDot | firstDot = fullyQualified.indexOf(".", 0, 0) |
    type2 = fullyQualified.prefix(firstDot) and
    path =
      ("Member[" + fullyQualified.suffix(firstDot + 1).replaceAll(".", "].Member[") + "]")
          .replaceAll(".Member[__init__].", "")
          .replaceAll("Member[__init__].", "")
  )
}

pragma[inline]
string computeArgumentPosition(string parameter, Function function) {
  exists(int index |
    parameter = function.getArg(index).getName() and
    result = index.toString()
  )
  or
  exists(function.getArgByName(parameter)) and
  result = parameter + ":"
}

bindingset[parameter, function]
pragma[inline]
string computeArgumentPath(string parameter, Function function) {
  result = "Argument[" + concat(computeArgumentPosition(parameter, function), ",") + "]"
}

bindingset[parameter, function]
pragma[inline]
string computeReturnPath(
  DataFlow::Node argument, string parameter, Function function, DataFlow::Node outNode
) {
  outNode.(DataFlow::CallCfgNode).getArg(_) = argument and
  result = "ReturnValue"
  or
  outNode.(DataFlow::CallCfgNode).getArgByName(_) = argument and
  result = "ReturnValue"
  or
  outNode.(DataFlow::MethodCallNode).getObject() = argument and
  result = "ReturnValue"
  or
  exists(DataFlow::MethodCallNode call |
    call.getObject() = outNode.(DataFlow::PostUpdateNode).getPreUpdateNode() and
    (
      call.getArg(_) = argument
      or
      call.getArgByName(_) = argument
    ) and
    result = "Argument[self:]"
  )
}

bindingset[parameter]
string madSummary(
  DataFlow::Node argument, string parameter, Function function, DataFlow::Node outNode
) {
  exists(string package, string functionPath, string argumentPath, string returnPath, string mode |
    fullyQualifiedToYamlFormat(computeFunctionName(function), package, functionPath) and
    (
      argumentPath = computeArgumentPath(parameter, function)
      or
      not exists(computeArgumentPath(parameter, function)) and
      argumentPath = "Argument[?]"
    ) and
    (
      returnPath = computeReturnPath(argument, parameter, function, outNode)
      or
      not exists(computeReturnPath(argument, parameter, function, outNode)) and
      returnPath =
        argument.getLocation().toString() + ": " + argument.toString() + " -> " + outNode.toString()
    ) and
    mode = "taint"
  |
    result =
      "- [\"" + package + "\", \"" + functionPath + "\", \"" + argumentPath + "\", \"" + returnPath +
        "\", \"" + mode + "\"]"
  )
}

abstract class EntryPointsByQuery extends string {
  bindingset[this]
  EntryPointsByQuery() { any() }

  abstract predicate subpath(
    DataFlow::Node argument, DataFlow::ParameterNode parameter, DataFlow::Node outNode
  );

  predicate entryPoint(
    DataFlow::Node argument, string parameterName, string functionName, DataFlow::Node outNode,
    string alreadyModeled, string madSummary
  ) {
    exists(DataFlow::ParameterNode parameter, Function function |
      parameterName = parameter.getParameter().getName() and
      functionName = computeFunctionName(function)
    |
      this.subpath(argument, parameter, outNode) and
      not inStdLib(argument) and
      inStdLib(parameter) and
      function = parameter.getScope() and
      alreadyModeled = stepsTo(argument, outNode) and
      (
        madSummary = madSummary(argument, parameterName, function, outNode)
        or
        not exists(madSummary(argument, parameterName, function, outNode)) and
        madSummary =
          argument.getLocation().toString() + ":" + argument.toString() + " -> " +
            outNode.toString()
      )
    )
  }
}
