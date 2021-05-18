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

abstract private class FluentLambdaMethod extends Method {
  /**
   * Holds if this lambda consumes taint from the quaifier when `lambdaArg`
   * for `methodArg` is tainted.
   * Eg. `tainted.map(stillTainted -> ..)`
   */
  abstract predicate consumesTaint(int methodArg, int lambdaArg);

  /**
   * Holds if the lambda passed at the given `arg` position produces taint
   * that taints the result of this method.
   * Eg. `var tainted = CompletableFuture.supplyAsync(() -> taint());`
   */
  predicate doesReturnTaint(int arg) { none() }
}

private class RatpackPromiseProviderMethod extends Method, FluentLambdaMethod {
  RatpackPromiseProviderMethod() { isStatic() and hasName(["flatten", "sync"]) }

  override predicate consumesTaint(int methodArg, int lambdaArg) { none() }

  override predicate doesReturnTaint(int arg) { arg = 0 }
}

abstract private class SimpleFluentLambdaMethod extends FluentLambdaMethod {
  override predicate consumesTaint(int methodArg, int lambdaArg) {
    methodArg = 0 and consumesTaint(lambdaArg)
  }

  /**
   * Holds if this lambda consumes taint from the quaifier when `arg` is tainted.
   * Eg. `tainted.map(stillTainted -> ..)`
   */
  abstract predicate consumesTaint(int lambdaArg);
}

private class RatpackPromiseMapMethod extends SimpleFluentLambdaMethod {
  RatpackPromiseMapMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName(["map", "blockingMap"]) // "flatMap" & "apply" cause false positives. Wait for fluent lambda support.
  }

  override predicate consumesTaint(int lambdaArg) { lambdaArg = 0 }

  override predicate doesReturnTaint(int arg) { arg = 0 }
}

/**
 * Represents the `mapIf` method.
 *
 * `<O> Promise<O> mapIf(Predicate<T> predicate, Function<T, O> onTrue, Function<T, O> onFalse)`
 */
private class RatpackPromiseMapIfMethod extends FluentLambdaMethod {
  RatpackPromiseMapIfMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName(["mapIf"]) and // "flatMapIf" causes false positives. Wait for fluent lambda support.
    getNumberOfParameters() = 3
  }

  override predicate consumesTaint(int methodArg, int lambdaArg) {
    methodArg = [1, 2, 3] and lambdaArg = 0
  }

  override predicate doesReturnTaint(int arg) { arg = [1, 2] }
}

private class RatpackPromiseMapErrorMethod extends FluentLambdaMethod {
  RatpackPromiseMapErrorMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName(["mapError"]) // "flatMapError" causes false positives. Wait for fluent lambda support.
  }

  override predicate consumesTaint(int methodArg, int lambdaArg) { none() }

  override predicate doesReturnTaint(int arg) { arg = getNumberOfParameters() - 1 }
}

private class RatpackPromiseThenMethod extends SimpleFluentLambdaMethod {
  RatpackPromiseThenMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName("then")
  }

  override predicate consumesTaint(int lambdaArg) { lambdaArg = 0 }
}

private class RatpackPromiseFluentMethod extends FluentMethod, FluentLambdaMethod {
  RatpackPromiseFluentMethod() {
    getDeclaringType() instanceof RatpackPromise and
    not isStatic() and
    exists(ParameterizedType t |
      t instanceof RatpackPromise and
      t = getDeclaringType() and
      t = getReturnType()
    )
  }

  override predicate consumesTaint(int methodArg, int lambdaArg) {
    hasName(["next"]) and methodArg = 0 and lambdaArg = 0
    or
    hasName(["cacheIf"]) and methodArg = 0 and lambdaArg = 0
    or
    hasName(["route"]) and methodArg = [0, 1] and lambdaArg = 0
  }

  override predicate doesReturnTaint(int arg) { none() } // "flatMapIf" causes false positives. Wait for fluent lambda support.
}

/**
 * Holds if the method access qualifier `node1` has dataflow to the functional expression parameter `node2`.
 */
private predicate stepIntoLambda(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, FluentLambdaMethod flm, int methodArg, int lambdaArg |
    flm.consumesTaint(methodArg, lambdaArg)
  |
    ma.getMethod() = flm and
    node1.asExpr() = ma.getQualifier() and
    ma.getArgument(methodArg).(FunctionalExpr).asMethod().getParameter(lambdaArg) =
      node2.asParameter()
  )
}

/**
 * Holds if the return statement result of the functional expression `node1` has dataflow to the
 * method access result `node2`.
 */
private predicate stepOutOfLambda(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FluentLambdaMethod flm, MethodAccess ma, FunctionalExpr fe, int arg |
    flm.doesReturnTaint(arg)
  |
    fe.asMethod().getBody().getAStmt().(ReturnStmt).getResult() = node1.asExpr() and
    ma.getMethod() = flm and
    node2.asExpr() = ma and
    ma.getArgument(arg) = fe
  )
}

private class RatpackPromiseTaintPreservingStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    stepIntoLambda(node1, node2) or
    stepOutOfLambda(node1, node2)
  }
}
