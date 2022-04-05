/** Definitions for the improper intent verification query. */

import java
import semmle.code.java.dataflow.DataFlow

/** An `onReceive` method of a `BroadcastReceiver` */
private class OnReceiveMethod extends Method {
  OnReceiveMethod() {
    this.getASourceOverriddenMethod*()
        .hasQualifiedName("android.content", "BroadcastReceiver", "onReceive")
  }

  /** Gets the paramter of this method that holds the received `Intent`. */
  Parameter getIntentParameter() { result = this.getParameter(1) }
}

/** A configuration to detect whether the `action` of an `Intent` is checked. */
private class VerifiedIntentConfig extends DataFlow::Configuration {
  VerifiedIntentConfig() { this = "VerifiedIntentConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asParameter() = any(OnReceiveMethod orm).getIntentParameter()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("android.content", "Intent", "getAction") and
      sink.asExpr() = ma.getQualifier()
    )
  }
}

/** An `onReceive` method that doesn't verify the action of the intent it recieves. */
class UnverifiedOnReceiveMethod extends OnReceiveMethod {
  UnverifiedOnReceiveMethod() {
    not any(VerifiedIntentConfig c).hasFlow(DataFlow::parameterNode(this.getIntentParameter()), _)
  }
}

/** Gets the name of an intent action that can only be sent by the system. */
string getASystemActionName() {
  result =
    [
      "AIRPLANE_MODE", "AIRPLANE_MODE_CHANGED", "APPLICATION_LOCALE_CHANGED",
      "APPLICATION_RESTRICTIONS_CHANGED", "BATTERY_CHANGED", "BATTERY_LOW", "BATTERY_OKAY",
      "BOOT_COMPLETED", "CONFIGURATION_CHANGED", "DEVICE_STORAGE_LOW", "DEVICE_STORAGE_OK",
      "DREAMING_STARTED", "DREAMING_STOPPED", "EXTERNAL_APPLICATIONS_AVAILABLE",
      "EXTERNAL_APPLICATIONS_UNAVAILABLE", "LOCALE_CHANGED", "LOCKED_BOOT_COMPLETED",
      "MY_PACKAGE_REPLACED", "MY_PACKAGE_SUSPENDED", "MY_PACKAGE_UNSUSPENDED", "NEW_OUTGOING_CALL",
      "PACKAGES_SUSPENDED", "PACKAGES_UNSUSPENDED", "PACKAGE_ADDED", "PACKAGE_CHANGED",
      "PACKAGE_DATA_CLEARED", "PACKAGE_FIRST_LAUNCH", "PACKAGE_FULLY_REMOVED", "PACKAGE_INSTALL",
      "PACKAGE_NEEDS_VERIFICATION", "PACKAGE_REMOVED", "PACKAGE_REPLACED", "PACKAGE_RESTARTED",
      "PACKAGE_VERIFIED", "POWER_CONNECTED", "POWER_DISCONNECTED", "REBOOT", "SCREEN_OFF",
      "SCREEN_ON", "SHUTDOWN", "TIMEZONE_CHANGED", "TIME_TICK", "UID_REMOVED", "USER_PRESENT"
    ]
}

/** An expression or XML attribute that contains the name of a system intent action. */
class SystemActionName extends Top {
  string name;

  SystemActionName() {
    name = getASystemActionName() and
    (
      this.(StringLiteral).getValue() = "android.intent.action." + name
      or
      this.(FieldRead).getField().hasQualifiedName("android.content", "Intent", "ACTION_" + name)
      or
      this.(XMLAttribute).getValue() = "android.intent.action." + name
    )
  }

  /** Gets the name of the system intent that this expression or attriute represents. */
  string getName() { result = name }
}

/** A call to `Context.registerReceiver` */
private class RegisterReceiverCall extends MethodAccess {
  RegisterReceiverCall() {
    this.getMethod()
        .getASourceOverriddenMethod*()
        .hasQualifiedName("android.content", "Context", "registerReceiver")
  }

  /** Gets the `BroadcastReceiver` argument to this call. */
  Expr getReceiverArgument() { result = this.getArgument(0) }

  /** Gets the `IntentFilter` argument to this call. */
  Expr getFilterArgument() { result = this.getArgument(1) }
}

/** A configuration to detect uses of `registerReceiver` with system intent actions. */
private class RegisterSystemActionConfig extends DataFlow::Configuration {
  RegisterSystemActionConfig() { this = "RegisterSystemActionConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SystemActionName }

  override predicate isSink(DataFlow::Node node) {
    exists(RegisterReceiverCall ma | node.asExpr() = ma.getFilterArgument())
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ConstructorCall cc |
      cc.getConstructedType().hasQualifiedName("android.content", "IntentFilter") and
      node1.asExpr() = cc.getArgument(0) and
      node2.asExpr() = cc
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("android.content", "IntentFilter", "create") and
      node1.asExpr() = ma.getArgument(0) and
      node2.asExpr() = ma
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("android.content", "IntentFilter", "addAction") and
      node1.asExpr() = ma.getArgument(0) and
      node2.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma.getQualifier()
    )
  }
}

/** Holds if `rrc` registers a reciever `orm` to recieve the system action `sa` that doesn't verifiy intents it recieves. */
predicate registeredUnverifiedSystemReceiver(
  RegisterReceiverCall rrc, UnverifiedOnReceiveMethod orm, SystemActionName sa
) {
  exists(RegisterSystemActionConfig conf, ConstructorCall cc |
    conf.hasFlow(DataFlow::exprNode(sa), DataFlow::exprNode(rrc.getFilterArgument())) and
    cc.getConstructedType() = orm.getDeclaringType() and
    DataFlow::localExprFlow(cc, rrc.getReceiverArgument())
  )
}

/** Holds if the XML element `rec` declares a reciever `orm` to recieve the system action named `sa` that doesn't verifiy intents it recieves. */
predicate xmlUnverifiedSystemReceiver(
  XMLElement rec, UnverifiedOnReceiveMethod orm, SystemActionName sa
) {
  exists(XMLElement filter, XMLElement action, Class ormty |
    rec.hasName("receiver") and
    filter.hasName("intent-filter") and
    action.hasName("action") and
    filter = rec.getAChild() and
    action = rec.getAChild() and
    ormty = orm.getDeclaringType() and
    rec.getAttribute("android:name").getValue() = ["." + ormty.getName(), ormty.getQualifiedName()] and
    action.getAttribute("android:name") = sa
  )
}

/** Holds if `reg` registers (either explicitly or through XML) a reciever `orm` to recieve the system action named `sa` that doesn't verify intents it recieves. */
predicate unverifiedSystemReceiver(Top reg, Method orm, SystemActionName sa) {
  registeredUnverifiedSystemReceiver(reg, orm, sa) or
  xmlUnverifiedSystemReceiver(reg, orm, sa)
}
