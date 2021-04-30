import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/** A reference type that extends a parameterization the Promise type. */
private class RatpackPromise extends RefType {
  RatpackPromise() {
    getSourceDeclaration().getASourceSupertype*().hasQualifiedName("ratpack.exec", "Promise")
  }
}

private class RatpackPromiseValueMethod extends Method, TaintPreservingCallable {
  RatpackPromiseValueMethod() { isStatic() and hasName("value") }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

abstract private class SimpleFluentLambdaMethod extends Method {
  SimpleFluentLambdaMethod() { getNumberOfParameters() = 1 }

  /**
   * Holds if this lambda consumes taint from the quaifier when `arg` is tainted.
   * Eg. `tainted.map(stillTainted -> ..)`
   */
  abstract predicate consumesTaint(int arg);

  /**
   * Holds if the lambda passed produces taint that taints the result of this method.
   * Eg. `var tainted = CompletableFuture.supplyAsync(() -> taint());`
   */
  predicate doesReturnTaint() { none() }
}

private class RatpackPromiseMapMethod extends SimpleFluentLambdaMethod {
  RatpackPromiseMapMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName(["map", "flatMap"])
  }

  override predicate consumesTaint(int arg) { arg = 0 }

  override predicate doesReturnTaint() { any() }
}

private class RatpackPromiseThenMethod extends SimpleFluentLambdaMethod {
  RatpackPromiseThenMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName("then")
  }

  override predicate consumesTaint(int arg) { arg = 0 }
}

private class RatpackPromiseNextMethod extends FluentMethod, SimpleFluentLambdaMethod {
  RatpackPromiseNextMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName("next")
  }

  override predicate consumesTaint(int arg) { arg = 0 }
}

private class RatpackPromiseTaintPreservingStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    stepIntoLambda(node1, node2) or
    stepOutOfLambda(node1, node2)
  }

  /**
   * Holds if the method access qualifier `node1` has dataflow to the functional expression parameter `node2`.
   */
  predicate stepIntoLambda(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma, SimpleFluentLambdaMethod sflm, int arg | sflm.consumesTaint(arg) |
      ma.getMethod() = sflm and
      node1.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(FunctionalExpr).asMethod().getParameter(arg) = node2.asParameter()
    )
  }

  /**
   * Holds if the return statement result of the functional expression `node1` has dataflow to the
   * method access result `node2`.
   */
  predicate stepOutOfLambda(DataFlow::Node node1, DataFlow::Node node2) {
    exists(SimpleFluentLambdaMethod sflm, MethodAccess ma, FunctionalExpr fe |
      sflm.doesReturnTaint()
    |
      fe.asMethod().getBody().getAStmt().(ReturnStmt).getResult() = node1.asExpr() and
      ma.getMethod() = sflm and
      node2.asExpr() = ma and
      ma.getArgument(0) = fe
    )
  }
}
