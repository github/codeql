import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/** A reference type that extends a parameterization the Promise type. */
class RatpackPromise extends RefType {
  RatpackPromise() {
    getSourceDeclaration().getASourceSupertype*().hasQualifiedName("ratpack.exec", "Promise")
  }
}

class RatpackPromiseMapMethod extends Method {
  RatpackPromiseMapMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName("map")
  }
}

class RatpackPromiseMapMethodAccess extends MethodAccess {
  RatpackPromiseMapMethodAccess() { getMethod() instanceof RatpackPromiseMapMethod }
}

class RatpackPromiseThenMethod extends Method {
  RatpackPromiseThenMethod() {
    getDeclaringType() instanceof RatpackPromise and
    hasName("then")
  }
}

class RatpackPromiseThenMethodAccess extends MethodAccess {
  RatpackPromiseThenMethodAccess() { getMethod() instanceof RatpackPromiseThenMethod }
}

private class RatpackPromiseTaintPreservingCallable extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    stepFromFunctionalExpToPromise(node1, node2) or
    stepFromPromiseToFunctionalArgument(node1, node2)
  }

  /**
   * Tracks taint from return from lambda function to the outer `Promise`.
   */
  private predicate stepFromFunctionalExpToPromise(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionalExpr fe |
      fe.asMethod().getBody().getAStmt().(ReturnStmt).getResult() = node1.asExpr() and
      node2.asExpr().(RatpackPromiseMapMethodAccess).getArgument(0) = fe
    )
  }

  /**
   * Tracks taint from the previous `Promise` to the first argument of lambda passed to `map` or `then`.
   */
  private predicate stepFromPromiseToFunctionalArgument(DataFlow::Node node1, DataFlow::Node node2) {
    exists(RatpackPromiseMapMethodAccess ma |
      node1.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(FunctionalExpr).asMethod().getParameter(0) = node2.asParameter()
    )
    or
    exists(RatpackPromiseThenMethodAccess ma |
      node1.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(FunctionalExpr).asMethod().getParameter(0) = node2.asParameter()
    )
  }
}
