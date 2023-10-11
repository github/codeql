/** Definitions related to `java.lang.ThreadLocal`. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/**
 * Holds if `cie` construct a `ThreadLocal` object with an overridden
 * `initialValue` method with a return value of `init`, such that `init` is the
 * initial value of the `ThreadLocal` object.
 */
private predicate threadLocalInitialValue(ClassInstanceExpr cie, Method initialValue, Expr init) {
  exists(RefType t, ReturnStmt ret |
    cie.getConstructedType().getSourceDeclaration() = t and
    t.getASourceSupertype+().hasQualifiedName("java.lang", "ThreadLocal") and
    ret.getResult() = init and
    ret.getEnclosingCallable() = initialValue and
    initialValue.hasName("initialValue") and
    initialValue.getDeclaringType() = t
  )
}

private class ThreadLocalInitialValueStore extends AdditionalStoreStep {
  override predicate step(DataFlow::Node node1, DataFlow::Content c, DataFlow::Node node2) {
    exists(Method initialValue, Expr init |
      threadLocalInitialValue(_, initialValue, init) and
      node1.asExpr() = init and
      node2.(DataFlow::InstanceParameterNode).getCallable() = initialValue and
      c.(DataFlow::SyntheticFieldContent).getField() = "java.lang.ThreadLocal.value"
    )
  }
}

private class ThreadLocalInitialValueStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ClassInstanceExpr cie, Method initialValue |
      threadLocalInitialValue(cie, initialValue, _) and
      node1.(DataFlow::InstanceParameterNode).getCallable() = initialValue and
      node2.asExpr() = cie
    )
  }
}
