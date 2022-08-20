/** Definitions for the improper intent verification query. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.xml.AndroidManifest
import semmle.code.java.frameworks.android.Intent

/** An `onReceive` method of a `BroadcastReceiver` */
private class OnReceiveMethod extends Method {
  OnReceiveMethod() { this.getASourceOverriddenMethod*() instanceof AndroidReceiveIntentMethod }

  /** Gets the parameter of this method that holds the received `Intent`. */
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

/** An `onReceive` method that doesn't verify the action of the intent it receives. */
private class UnverifiedOnReceiveMethod extends OnReceiveMethod {
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
class SystemActionName extends AndroidActionXmlElement {
  string name;

  SystemActionName() {
    name = getASystemActionName() and
    this.getActionName() = "android.intent.action." + name
  }

  /** Gets the name of the system intent that this expression or attribute represents. */
  string getSystemActionName() { result = name }
}

/** Holds if the XML element `rec` declares a receiver `orm` to receive the system action named `sa` that doesn't verify intents it receives. */
predicate unverifiedSystemReceiver(
  AndroidReceiverXmlElement rec, UnverifiedOnReceiveMethod orm, SystemActionName sa
) {
  exists(Class ormty |
    ormty = orm.getDeclaringType() and
    rec.getComponentName() = ["." + ormty.getName(), ormty.getQualifiedName()] and
    rec.getAnIntentFilterElement().getAnActionElement() = sa
  )
}
