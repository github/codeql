/** Definitions related to `java.util.stream`. */

private import semmle.code.java.dataflow.FlowSummary

private class CollectCall extends MethodCall {
  CollectCall() {
    this.getMethod()
        .getSourceDeclaration()
        .hasQualifiedName("java.util.stream", "Stream", "collect")
  }
}

private class Collector extends MethodCall {
  Collector() {
    this.getMethod().getDeclaringType().hasQualifiedName("java.util.stream", "Collectors")
  }

  predicate hasName(string name) { this.getMethod().hasName(name) }
}

private class CollectToContainer extends SyntheticCallable {
  CollectToContainer() { this = "java.util.stream.collect()+Collectors.[toList,...]" }

  override Call getACall() {
    result
        .(CollectCall)
        .getArgument(0)
        .(Collector)
        .hasName([
            "maxBy", "minBy", "toCollection", "toList", "toSet", "toUnmodifiableList",
            "toUnmodifiableSet"
          ])
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[this].Element" and
    output = "ReturnValue.Element" and
    preservesValue = true
  }
}

private class CollectToJoining extends SyntheticCallable {
  CollectToJoining() { this = "java.util.stream.collect()+Collectors.joining" }

  override Call getACall() { result.(CollectCall).getArgument(0).(Collector).hasName("joining") }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[this].Element" and
    output = "ReturnValue" and
    preservesValue = false
  }

  override Type getReturnType() { result instanceof TypeString }
}

private class CollectToGroupingBy extends SyntheticCallable {
  CollectToGroupingBy() {
    this = "java.util.stream.collect()+Collectors.[groupingBy(Function),...]"
  }

  override Call getACall() {
    exists(Method m |
      m = result.(CollectCall).getArgument(0).(Collector).getMethod() and
      m.hasName(["groupingBy", "groupingByConcurrent", "partitioningBy"]) and
      m.getNumberOfParameters() = 1
    )
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[this].Element" and
    output = "ReturnValue.MapValue.Element" and
    preservesValue = true
  }
}
