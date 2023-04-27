/** Definitions related to `java.util.stream`. */

private import semmle.code.java.dataflow.FlowSummary

private class CollectCall extends MethodAccess {
  CollectCall() {
    this.getMethod()
        .getSourceDeclaration()
        .hasQualifiedName("java.util.stream", "Stream", "collect")
  }
}

private class Collector extends MethodAccess {
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

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    input = SummaryComponentStack::elementOf(SummaryComponentStack::qualifier()) and
    output = SummaryComponentStack::elementOf(SummaryComponentStack::return()) and
    preservesValue = true
  }
}

private class CollectToJoining extends SyntheticCallable {
  CollectToJoining() { this = "java.util.stream.collect()+Collectors.joining" }

  override Call getACall() { result.(CollectCall).getArgument(0).(Collector).hasName("joining") }

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    input = SummaryComponentStack::elementOf(SummaryComponentStack::qualifier()) and
    output = SummaryComponentStack::return() and
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

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    input = SummaryComponentStack::elementOf(SummaryComponentStack::qualifier()) and
    output =
      SummaryComponentStack::elementOf(SummaryComponentStack::mapValueOf(SummaryComponentStack::return())) and
    preservesValue = true
  }
}

private class RequiredComponentStackForCollect extends RequiredSummaryComponentStack {
  override predicate required(SummaryComponent head, SummaryComponentStack tail) {
    head = SummaryComponent::element() and
    tail = SummaryComponentStack::qualifier()
    or
    head = SummaryComponent::element() and
    tail = SummaryComponentStack::return()
    or
    head = SummaryComponent::element() and
    tail = SummaryComponentStack::mapValueOf(SummaryComponentStack::return())
    or
    head = SummaryComponent::mapValue() and
    tail = SummaryComponentStack::return()
  }
}
