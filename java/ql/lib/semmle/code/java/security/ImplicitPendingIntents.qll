/** Provides classes and predicates for working with implicit `PendingIntent`s. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.android.Intent
private import semmle.code.java.frameworks.android.PendingIntent

/** A source for an implicit `PendingIntent` flow. */
abstract class ImplicitPendingIntentSource extends DataFlow::Node {
  /** Holds if this source has the specified `state`. */
  predicate hasState(DataFlow::FlowState state) { state = "" }
}

/** A sink that sends an implicit and mutable `PendingIntent` to a third party. */
abstract class ImplicitPendingIntentSink extends DataFlow::Node {
  /** Holds if this sink has the specified `state`. */
  predicate hasState(DataFlow::FlowState state) { state = "" }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to flows related to the use
 * of implicit `PendingIntent`s.
 */
class ImplicitPendingIntentAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related to the use of implicit `PendingIntent`s.
   */
  predicate step(DataFlow::Node node1, DataFlow::Node node2) { none() }

  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related to the use of implicit `PendingIntent`s. This step is only applicable
   * in `state1` and updates the flow state to `state2`.
   */
  predicate step(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }
}

private class IntentCreationSource extends ImplicitPendingIntentSource {
  IntentCreationSource() {
    exists(ClassInstanceExpr cc |
      cc.getConstructedType() instanceof TypeIntent and this.asExpr() = cc
    )
  }
}

private class SendPendingIntent extends ImplicitPendingIntentSink {
  SendPendingIntent() {
    sinkNode(this, "intent-start") and
    // implicit intents can't be started as services since API 21
    not exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType().getAnAncestor() instanceof TypeContext and
      m.getName().matches(["start%Service%", "bindService%"]) and
      this.asExpr() = ma.getArgument(0)
    )
    or
    sinkNode(this, "pending-intent-sent")
  }

  override predicate hasState(DataFlow::FlowState state) { state = "MutablePendingIntent" }
}

private class MutablePendingIntentFlowStep extends ImplicitPendingIntentAdditionalTaintStep {
  override predicate step(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    state1 = "" and
    state2 = "MutablePendingIntent" and
    exists(PendingIntentCreation pic, Argument flagArg |
      node1.asExpr() = pic.getIntentArg() and
      node2.asExpr() = pic and
      flagArg = pic.getFlagsArg()
    |
      // We err on the side of false positives here, assuming a PendingIntent may be mutable
      // unless it is at least sometimes explicitly marked immutable and never marked mutable.
      // Note: for API level < 31, PendingIntents were mutable by default, whereas since then
      // they are immutable by default.
      not bitwiseLocalTaintStep*(DataFlow::exprNode(any(ImmutablePendingIntentFlag flag)
              .getAnAccess()), DataFlow::exprNode(flagArg))
      or
      bitwiseLocalTaintStep*(DataFlow::exprNode(any(MutablePendingIntentFlag flag).getAnAccess()),
        DataFlow::exprNode(flagArg))
    )
  }
}

/**
 * Holds if taint can flow from `source` to `sink` in one local step,
 * including bitwise operations.
 */
private predicate bitwiseLocalTaintStep(DataFlow::Node source, DataFlow::Node sink) {
  TaintTracking::localTaintStep(source, sink) or
  source.asExpr() = sink.asExpr().(BitwiseExpr).(BinaryExpr).getAnOperand()
}
