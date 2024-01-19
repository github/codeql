/** Definitions for Android Sensitive UI queries */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.SensitiveActions
private import semmle.code.java.frameworks.android.Layout

/** A configuration for tracking sensitive information to system notifications. */
private module NotificationTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "notification") }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    isSink(node) and exists(c)
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/** Taint tracking flow for sensitive data flowing to system notifications. */
module NotificationTracking = TaintTracking::Global<NotificationTrackingConfig>;

/** A call to a method that sets the text of a `TextView`. */
private class SetTextCall extends MethodCall {
  SetTextCall() {
    this.getMethod()
        .getAnOverride*()
        .hasQualifiedName("android.widget", "TextView", ["append", "setText", "setHint"]) and
    (
      this.getMethod()
          .getParameter(0)
          .getType()
          .(RefType)
          .hasQualifiedName("java.lang", "CharSequence")
      or
      this.getMethod().getParameter(0).getType().(Array).getElementType() instanceof CharacterType
    )
  }

  /** Gets the string argument of this call. */
  Expr getStringArgument() { result = this.getArgument(0) }
}

/** A call to a method indicating that the contents of a UI element are safely masked. */
private class MaskCall extends MethodCall {
  MaskCall() {
    this.getMethod().hasQualifiedName("android.widget", "TextView", "setInputType")
    or
    this.getMethod().hasQualifiedName("android.widget", "view", "setVisibility")
  }
}

/** A configuration for tracking sensitive information to text fields. */
private module TextFieldTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node sink) {
    exists(SetTextCall call |
      sink.asExpr() = call.getStringArgument() and
      not isMasked(call)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/** Holds if the qualifier of `call` is also called with a method that may mask the information displayed. */
private predicate isMasked(SetTextCall call) {
  exists(string id |
    DataFlow::localExprFlow(getAUseOfViewWithId(id), call.getQualifier()) and
    DataFlow::localExprFlow(getAUseOfViewWithId(id), any(MaskCall mcall).getQualifier())
  )
}

/** Taint tracking flow for sensitive data flowing to text fields. */
module TextFieldTracking = TaintTracking::Global<NotificationTrackingConfig>;
