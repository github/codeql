/**
 * @name Broadcasting sensitive data to all Android applications
 * @id java/sensitive-broadcast
 * @description An Android application uses implicit intents to broadcast sensitive data to all applications without specifying any receiver permission.
 * @kind path-problem
 * @tags security
 *       external/cwe-927
 */

import java
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.security.SensitiveActions
import DataFlow::PathGraph

/**
 * Gets regular expression for matching names of Android variables that indicate the value being held contains sensitive information.
 */
private string getAndroidSensitiveInfoRegex() { result = "(?i).*(email|phone|ticket).*" }

/**
 * Method call to pass information to the `Intent` object.
 */
class PutIntentExtraMethodAccess extends MethodAccess {
  PutIntentExtraMethodAccess() {
    (
      getMethod().getName().matches("put%Extra") or
      getMethod().hasName("putExtras")
    ) and
    getMethod().getDeclaringType() instanceof TypeIntent
  }
}

/**
 * Method call to pass information to the intent extra bundle object.
 */
class PutBundleExtraMethodAccess extends MethodAccess {
  PutBundleExtraMethodAccess() {
    getMethod().getName().regexpMatch("put\\w+") and
    getMethod().getDeclaringType().getASupertype*().hasQualifiedName("android.os", "BaseBundle")
  }
}

/** Finds variables that hold sensitive information judging by their names. */
class SensitiveInfoExpr extends Expr {
  SensitiveInfoExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch([getCommonSensitiveInfoRegex(), getAndroidSensitiveInfoRegex()])
    )
  }
}

/**
 * A method access of the `Context.sendBroadcast` family.
 */
class SendBroadcastMethodAccess extends MethodAccess {
  SendBroadcastMethodAccess() {
    this.getMethod().getDeclaringType() instanceof TypeContext and
    this.getMethod().getName().matches("send%Broadcast%")
  }
}

private class NullArgFlowConfig extends DataFlow2::Configuration {
  NullArgFlowConfig() { this = "Flow configuration with a null argument" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof NullLiteral }

  override predicate isSink(DataFlow::Node sink) {
    exists(SendBroadcastMethodAccess ma | sink.asExpr() = ma.getAnArgument())
  }
}

private class EmptyArrayArgFlowConfig extends DataFlow3::Configuration {
  EmptyArrayArgFlowConfig() { this = "Flow configuration with an empty array argument" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(ArrayCreationExpr).getFirstDimensionSize() = 0
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(SendBroadcastMethodAccess ma | sink.asExpr() = ma.getAnArgument())
  }
}

/**
 * Holds if a `sendBroadcast` call doesn't specify receiver permission.
 */
predicate isSensitiveBroadcastSink(DataFlow::Node sink) {
  exists(SendBroadcastMethodAccess ma |
    sink.asExpr() = ma.getAnArgument() and
    (
      ma.getMethod().hasName("sendBroadcast") and
      (
        ma.getNumArgument() = 1 // sendBroadcast(Intent intent)
        or
        // sendBroadcast(Intent intent, String receiverPermission)
        exists(NullArgFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(ma.getArgument(1))))
      )
      or
      ma.getMethod().hasName("sendBroadcastAsUser") and
      (
        ma.getNumArgument() = 2 or // sendBroadcastAsUser(Intent intent, UserHandle user)
        exists(NullArgFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(ma.getArgument(2)))) // sendBroadcastAsUser(Intent intent, UserHandle user, String receiverPermission)
      )
      or
      ma.getMethod().hasName("sendBroadcastWithMultiplePermissions") and
      exists(EmptyArrayArgFlowConfig config |
        config.hasFlow(_, DataFlow::exprNode(ma.getArgument(1))) // sendBroadcastWithMultiplePermissions(Intent intent, String[] receiverPermissions)
      )
      or
      // Method calls of `sendOrderedBroadcast` whose second argument is always `receiverPermission`
      ma.getMethod().hasName("sendOrderedBroadcast") and
      (
        // sendOrderedBroadcast(Intent intent, String receiverPermission) or sendOrderedBroadcast(Intent intent, String receiverPermission, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
        exists(NullArgFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(ma.getArgument(1)))) and
        ma.getNumArgument() <= 7
        or
        // sendOrderedBroadcast(Intent intent, String receiverPermission, String receiverAppOp, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
        exists(NullArgFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(ma.getArgument(1)))) and
        exists(NullArgFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(ma.getArgument(2)))) and
        ma.getNumArgument() = 8
      )
      or
      // Method call of `sendOrderedBroadcastAsUser(Intent intent, UserHandle user, String receiverPermission, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)`
      ma.getMethod().hasName("sendOrderedBroadcastAsUser") and
      exists(NullArgFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(ma.getArgument(2))))
    )
  )
}

/**
 * Taint configuration tracking flow from variables containing sensitive information to broadcast intents.
 */
class SensitiveBroadcastConfig extends TaintTracking::Configuration {
  SensitiveBroadcastConfig() { this = "Sensitive Broadcast Configuration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof SensitiveInfoExpr
  }

  override predicate isSink(DataFlow::Node sink) { isSensitiveBroadcastSink(sink) }

  /**
   * Holds if there is an additional flow step from `PutIntentExtraMethodAccess` or `PutBundleExtraMethodAccess` that taints the `Intent` or its extras `Bundle`.
   */
  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(PutIntentExtraMethodAccess pia |
      node1.asExpr() = pia.getAnArgument() and node2.asExpr() = pia.getQualifier()
    )
    or
    exists(PutBundleExtraMethodAccess pba |
      node1.asExpr() = pba.getAnArgument() and node2.asExpr() = pba.getQualifier()
    )
  }

  /**
   * Holds if broadcast doesn't specify receiving package name of the 3rd party app
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodAccess setReceiverMa |
      setReceiverMa.getMethod().hasName(["setPackage", "setClass", "setClassName", "setComponent"]) and
      setReceiverMa.getQualifier().(VarAccess).getVariable().getAnAccess() = node.asExpr()
    )
  }
}

from SensitiveBroadcastConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Sending $@ to broadcast.", source.getNode(),
  "sensitive information"
