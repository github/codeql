/** Provides definitions to reason about Android Sensitive Broadcast queries */

import java
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.security.SensitiveActions

/**
 * Gets regular expression for matching names of Android variables that indicate the value being held contains sensitive information.
 */
private string getAndroidSensitiveInfoRegex() { result = "(?i).*(email|phone|ticket).*" }

/** Finds variables that hold sensitive information judging by their names. */
private class SensitiveInfoExpr extends Expr {
  SensitiveInfoExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().regexpMatch([getCommonSensitiveInfoRegex(), getAndroidSensitiveInfoRegex()])
    )
  }
}

/**
 * A method access of the `Context.sendBroadcast` family.
 */
private class SendBroadcastMethodAccess extends MethodAccess {
  SendBroadcastMethodAccess() {
    this.getMethod().getDeclaringType().getASourceSupertype*() instanceof TypeContext and
    this.getMethod().getName().matches("send%Broadcast%")
  }
}

private predicate isNullArg(Expr ex) {
  exists(DataFlow::Node src, DataFlow::Node sink, SendBroadcastMethodAccess ma |
    ex = ma.getAnArgument() and
    sink.asExpr() = ex and
    src.asExpr() instanceof NullLiteral
  |
    DataFlow::localFlow(src, sink)
  )
}

private predicate isEmptyArrayArg(Expr ex) {
  exists(DataFlow::Node src, DataFlow::Node sink, SendBroadcastMethodAccess ma |
    ex = ma.getAnArgument() and
    sink.asExpr() = ex and
    src.asExpr().(ArrayCreationExpr).getFirstDimensionSize() = 0
  |
    DataFlow::localFlow(src, sink)
  )
}

/**
 * Holds if a `sendBroadcast` call doesn't specify receiver permission.
 */
private predicate isSensitiveBroadcastSink(DataFlow::Node sink) {
  exists(SendBroadcastMethodAccess ma, string name | ma.getMethod().hasName(name) |
    sink.asExpr() = ma.getAnArgument() and
    (
      name = "sendBroadcast" and
      (
        // sendBroadcast(Intent intent)
        ma.getNumArgument() = 1
        or
        // sendBroadcast(Intent intent, String receiverPermission)
        isNullArg(ma.getArgument(1))
      )
      or
      name = "sendBroadcastAsUser" and
      (
        // sendBroadcastAsUser(Intent intent, UserHandle user)
        ma.getNumArgument() = 2
        or
        // sendBroadcastAsUser(Intent intent, UserHandle user, String receiverPermission)
        isNullArg(ma.getArgument(2))
      )
      or
      // sendBroadcastWithMultiplePermissions(Intent intent, String[] receiverPermissions)
      name = "sendBroadcastWithMultiplePermissions" and
      isEmptyArrayArg(ma.getArgument(1))
      or
      // Method calls of `sendOrderedBroadcast` whose second argument is always `receiverPermission`
      name = "sendOrderedBroadcast" and
      (
        // sendOrderedBroadcast(Intent intent, String receiverPermission)
        // sendOrderedBroadcast(Intent intent, String receiverPermission, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
        isNullArg(ma.getArgument(1)) and
        ma.getNumArgument() = [2, 7]
        or
        // sendOrderedBroadcast(Intent intent, String receiverPermission, String receiverAppOp, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
        isNullArg(ma.getArgument(1)) and
        isNullArg(ma.getArgument(2)) and
        ma.getNumArgument() = 8
      )
      or
      // sendOrderedBroadcastAsUser(Intent intent, UserHandle user, String receiverPermission, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
      name = "sendOrderedBroadcastAsUser" and
      isNullArg(ma.getArgument(2))
      or
      // sendStickyBroadcast(Intent intent)
      // sendStickyBroadcast(Intent intent, Bundle options)
      // sendStickyBroadcastAsUser(Intent intent, UserHandle user)
      // sendStickyOrderedBroadcast(Intent intent, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
      // sendStickyOrderedBroadcastAsUser(Intent intent, UserHandle user, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)
      name =
        [
          "sendStickyBroadcast", "sendStickyBroadcastAsUser", "sendStickyOrderedBroadcast",
          "sendStickyOrderedBroadcastAsUser"
        ]
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
   * Holds if broadcast doesn't specify receiving package name of the 3rd party app
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodAccess setReceiverMa |
      setReceiverMa.getMethod().hasName(["setPackage", "setClass", "setClassName", "setComponent"]) and
      setReceiverMa.getQualifier().(VarAccess).getVariable().getAnAccess() = node.asExpr()
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    super.allowImplicitRead(node, c)
    or
    this.isSink(node)
  }
}
