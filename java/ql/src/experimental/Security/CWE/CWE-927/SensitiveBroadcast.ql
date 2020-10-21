/**
 * @name Use of Implicit Intent for Sensitive Communication
 * @id java/sensitive-broadcast
 * @description An Android application uses implicit intents to broadcast sensitive data to all applications without specifying any receiver permission.
 * @kind path-problem
 * @tags security
 *       external/cwe-927
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

/**
 * Gets a regular expression for matching names of variables that indicate the value being held contains sensitive information.
 */
private string getSensitiveInfoRegex() {
  result = "(?i).*challenge|pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i).*(token|email|phone|username|userid|ticket).*"
}

/**
 * Method call to pass information to the `Intent` object either directly through intent extra or indirectly through intent extra bundle.
 */
class PutExtraMethodAccess extends MethodAccess {
  PutExtraMethodAccess() {
    getMethod().getName().regexpMatch("put\\w*Extra(s*)") and
    getMethod().getDeclaringType() instanceof TypeIntent and
    not exists(
      MethodAccess setPackageVa // Intent without specifying receiving package name of the 3rd party app
    |
      setPackageVa.getMethod().hasName(["setPackage", "setClass", "setClassName", "setComponent"]) and
      setPackageVa.getQualifier().(VarAccess).getVariable().getAnAccess() = getQualifier()
    )
    or
    getMethod().getName().regexpMatch("put\\w+") and
    getMethod().getDeclaringType().hasQualifiedName("android.os", "Bundle")
  }
}

/** Finds variables that hold sensitive information judging by their names. */
class SensitiveInfoExpr extends Expr {
  SensitiveInfoExpr() {
    exists(Variable v | this = v.getAnAccess() |
      v.getName().toLowerCase().regexpMatch(getSensitiveInfoRegex())
    )
  }
}

/**
 * The method access of `context.sendBroadcast`.
 */
class SendBroadcastMethodAccess extends MethodAccess {
  SendBroadcastMethodAccess() {
    this.getMethod().getDeclaringType() instanceof TypeContext and
    this.getMethod().getName().matches("send%Broadcast%")
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
        ma.getNumArgument() = 1 or // sendBroadcast(Intent intent)
        ma.getArgument(1) instanceof NullLiteral // sendBroadcast(Intent intent, String receiverPermission)
      )
      or
      ma.getMethod().hasName("sendBroadcastAsUser") and
      (
        ma.getNumArgument() = 2 or // sendBroadcastAsUser(Intent intent, UserHandle user)
        ma.getArgument(2) instanceof NullLiteral // sendBroadcastAsUser(Intent intent, UserHandle user, String receiverPermission)
      )
      or
      ma.getMethod().hasName("sendBroadcastWithMultiplePermissions") and
      (
        ma.getArgument(1).(ArrayCreationExpr).getFirstDimensionSize() = 0 // sendBroadcastWithMultiplePermissions(Intent intent, String[] receiverPermissions)
        or
        exists(Variable v |
          v.getAnAccess() = ma.getArgument(1) and
          v.getAnAssignedValue().(ArrayCreationExpr).getFirstDimensionSize() = 0
        )
      )
      or
      //Method calls of `sendOrderedBroadcast` whose second argument is always `receiverPermission`
      ma.getMethod().hasName("sendOrderedBroadcast") and
      (
        ma.getArgument(1) instanceof NullLiteral and ma.getNumArgument() <=7
        or
        ma.getArgument(1) instanceof NullLiteral and
        ma.getArgument(2) instanceof NullLiteral and
        ma.getNumArgument() = 8
      )
      or
      //Method call of `sendOrderedBroadcastAsUser(Intent intent, UserHandle user, String receiverPermission, BroadcastReceiver resultReceiver, Handler scheduler, int initialCode, String initialData, Bundle initialExtras)`
      ma.getMethod().hasName("sendOrderedBroadcastAsUser") and
      ma.getArgument(2) instanceof NullLiteral
    )
  )
}

/**
 * Taint configuration tracking flow from variables containing sensitive information to broadcasted intents.
 */
class SensitiveBroadcastConfig extends DataFlow::Configuration {
  SensitiveBroadcastConfig() { this = "Sensitive Broadcast Configuration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof SensitiveInfoExpr
  }

  override predicate isSink(DataFlow::Node sink) { isSensitiveBroadcastSink(sink) }

  /**
   * Holds if there is an additional flow step from `PutExtraMethodAccess` to a broadcasted intent.
   */
  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(PutExtraMethodAccess pa |
      node1.asExpr() = pa.getAnArgument() and node2.asExpr() = pa.getQualifier()
    )
  }
}

from SensitiveBroadcastConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Sending $@ to broadcast.", source.getNode(),
  "sensitive information"
