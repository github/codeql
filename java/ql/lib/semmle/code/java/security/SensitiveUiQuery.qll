/** Definitions for Android Sensitive UI queries */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.SensitiveActions
private import semmle.code.java.frameworks.android.Layout
private import semmle.code.java.security.Sanitizers

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
    this.getMethod().getAnOverride*().hasQualifiedName("android.widget", "TextView", "setInputType")
    or
    this.getMethod().getAnOverride*().hasQualifiedName("android.view", "View", "setVisibility")
  }
}

/**
 * A text field sink node.
 */
private class TextFieldSink extends ApiSinkNode {
  TextFieldSink() {
    exists(SetTextCall call |
      this.asExpr() = call.getStringArgument() and
      not setTextCallIsMasked(call)
    )
  }
}

/** A configuration for tracking sensitive information to text fields. */
private module TextFieldTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node sink) { sink instanceof TextFieldSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/** A local flow step that also flows through access to fields containing `View`s */
private predicate localViewFieldFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlowStep(node1, node2)
  or
  exists(Field f |
    f.getType().(Class).getASupertype*().hasQualifiedName("android.view", "View") and
    node1.asExpr() = f.getAnAccess().(FieldWrite).getASource() and
    node2.asExpr() = f.getAnAccess().(FieldRead)
  )
}

/** Holds if data can flow from `node1` to `node2` with local flow steps as well as flow through fields containing `View`s */
private predicate localViewFieldFlow(DataFlow::Node node1, DataFlow::Node node2) {
  localViewFieldFlowStep*(node1, node2)
}

/** Holds if data can flow from `e1` to `e2` with local flow steps as well as flow through fields containing `View`s */
private predicate localViewFieldExprFlow(Expr e1, Expr e2) {
  localViewFieldFlow(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/** Holds if the given view may be properly masked. */
private predicate viewIsMasked(AndroidLayoutXmlElement view) {
  localViewFieldExprFlow(getAUseOfViewWithId(view.getId()), any(MaskCall mcall).getQualifier())
  or
  view.getAttribute("inputType")
      .(AndroidXmlAttribute)
      .getValue()
      .regexpMatch("(?i).*(text|number)(web)?password.*")
  or
  view.getAttribute("visibility").(AndroidXmlAttribute).getValue().toLowerCase() =
    ["invisible", "gone"]
}

/** Holds if the qualifier of `call` may be properly masked. */
private predicate setTextCallIsMasked(SetTextCall call) {
  exists(AndroidLayoutXmlElement view |
    localViewFieldExprFlow(getAUseOfViewWithId(view.getId()), call.getQualifier()) and
    viewIsMasked(view.getParent*())
  )
}

/** Taint tracking flow for sensitive data flowing to text fields. */
module TextFieldTracking = TaintTracking::Global<TextFieldTrackingConfig>;
