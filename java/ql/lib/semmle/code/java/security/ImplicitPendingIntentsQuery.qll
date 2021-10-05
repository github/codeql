/** Provides taint tracking configurations to be used in queries related to implicit `PendingIntent`s. */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.security.ImplicitPendingIntents

/**
 * A taint tracking configuration for implicit `PendingIntent`s
 * being wrapped in another implicit `Intent` that gets started.
 */
class ImplicitPendingIntentStartConf extends TaintTracking::Configuration {
  ImplicitPendingIntentStartConf() { this = "ImplicitPendingIntentStartConf" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof ImplicitPendingIntentCreation
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SendPendingIntent }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof ExplicitIntentSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Field f |
      f.getType() instanceof PendingIntent and
      node1.(DataFlow::PostUpdateNode).getPreUpdateNode() =
        DataFlow::getFieldQualifier(f.getAnAccess().(FieldWrite)) and
      node2.asExpr().(FieldRead).getField() = f
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    super.allowImplicitRead(node, c) or
    this.isSink(node) or
    this.isAdditionalTaintStep(node, _)
  }
}

private class ImplicitPendingIntentCreation extends Expr {
  ImplicitPendingIntentCreation() {
    exists(Argument arg |
      this.getType() instanceof PendingIntent and
      exists(ImplicitPendingIntentConf conf | conf.hasFlowTo(DataFlow::exprNode(arg))) and
      arg.getCall() = this
    )
  }
}

private class SendPendingIntent extends DataFlow::Node {
  SendPendingIntent() {
    sinkNode(this, "intent-start") and
    // startService can't actually start implicit intents since API 21
    not exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType().getASupertype*() instanceof TypeContext and
      m.hasName("startService") and
      this.asExpr() = ma.getArgument(0)
    )
    or
    sinkNode(this, "pending-intent-sent")
  }
}

private class ImplicitPendingIntentConf extends DataFlow2::Configuration {
  ImplicitPendingIntentConf() { this = "PendingIntentConf" }

  override predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr cc |
      cc.getConstructedType() instanceof TypeIntent and source.asExpr() = cc
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof MutablePendingIntentSink }

  override predicate isBarrier(DataFlow::Node barrier) {
    barrier instanceof ExplicitIntentSanitizer
  }
}

private class PendingIntentSink extends DataFlow::Node {
  PendingIntentSink() { sinkNode(this, "pending-intent") }
}

private class MutablePendingIntentSink extends PendingIntentSink {
  MutablePendingIntentSink() {
    exists(Argument flagArgument |
      flagArgument = this.asExpr().(Argument).getCall().getArgument(3)
    |
      // API < 31, PendingIntents are mutable by default
      not TaintTracking::localExprTaint(getPendingIntentFlagAccess("FLAG_IMMUTABLE"), flagArgument)
      or
      // API >= 31, PendingIntents need to explicitly set mutability
      TaintTracking::localExprTaint(getPendingIntentFlagAccess("FLAG_MUTABLE"), flagArgument)
    )
  }
}

private Expr getPendingIntentFlagAccess(string flagName) {
  exists(Field f |
    f.getDeclaringType() instanceof PendingIntent and
    f.isPublic() and
    f.isFinal() and
    f.hasName(flagName) and
    f.getAnAccess() = result
  )
}
