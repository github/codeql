/** Provides classes and predicates for working with implicit `PendingIntent`s. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.android.Intent
private import semmle.code.java.frameworks.android.PendingIntent

/** A source for an implicit `PendingIntent` flow. */
abstract class ImplicitPendingIntentSource extends DataFlow::Node {
  predicate hasState(DataFlow::FlowState state) { state = "" }
}

/** A sink that sends an implicit and mutable `PendingIntent` to a third party. */
abstract class ImplicitPendingIntentSink extends DataFlow::Node {
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
      m.getDeclaringType().getASupertype*() instanceof TypeContext and
      m.getName().matches(["start%Service%", "bindService%"]) and
      this.asExpr() = ma.getArgument(0)
    )
    or
    sinkNode(this, "pending-intent-sent")
  }

  override predicate hasState(DataFlow::FlowState state) { state = "MutablePendingIntent" }
}

private class PendingIntentAsFieldAdditionalTaintStep extends ImplicitPendingIntentAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Field f |
      f.getType() instanceof PendingIntent and
      node1.(DataFlow::PostUpdateNode).getPreUpdateNode() =
        DataFlow::getFieldQualifier(f.getAnAccess().(FieldWrite)) and
      node2.asExpr().(FieldRead).getField() = f
    )
  }
}

private class MutablePendingIntentFlowStep extends PendingIntentAsFieldAdditionalTaintStep {
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
      // API < 31, PendingIntents are mutable by default
      not TaintTracking::localExprTaint(any(ImmutablePendingIntentFlag flag).getAnAccess(), flagArg)
      or
      // API >= 31, PendingIntents need to explicitly set mutability
      TaintTracking::localExprTaint(any(MutablePendingIntentFlag flag).getAnAccess(), flagArg)
    )
  }
}

private class PendingIntentSentSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice;SliceProvider;true;onBindSlice;;;ReturnValue;pending-intent-sent",
        "androidx.slice;SliceProvider;true;onCreatePermissionRequest;;;ReturnValue;pending-intent-sent",
        "android.app;NotificationManager;true;notify;(int,Notification);;Argument[1];pending-intent-sent",
        "android.app;NotificationManager;true;notify;(String,int,Notification);;Argument[2];pending-intent-sent",
        "android.app;NotificationManager;true;notifyAsPackage;(String,String,int,Notification);;Argument[3];pending-intent-sent",
        "android.app;NotificationManager;true;notifyAsUser;(String,int,Notification,UserHandle);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent,OnFinished,Handler,String,Bundle);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent,OnFinished,Handler,String);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent,OnFinished,Handler);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent);;Argument[2];pending-intent-sent",
        "android.app;Activity;true;setResult;(int,Intent);;Argument[1];pending-intent-sent"
      ]
  }
}
