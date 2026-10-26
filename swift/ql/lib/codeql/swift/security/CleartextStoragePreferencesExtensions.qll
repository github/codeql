/**
 * Provides classes and predicates for reasoning about cleartext preferences
 * storage vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for cleartext preferences storage vulnerabilities. That is,
 * a `DataFlow::Node` of something that gets stored in an application
 * preference store.
 */
abstract class CleartextStoragePreferencesSink extends DataFlow::Node {
  abstract string getStoreName();
}

/**
 * A barrier for cleartext preferences storage vulnerabilities.
 */
abstract class CleartextStoragePreferencesBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CleartextStoragePreferencesAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to cleartext preferences storage vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * The `DataFlow::Node` of an expression that gets written to the user defaults database.
 */
private class UserDefaultsStore extends CleartextStoragePreferencesSink {
  UserDefaultsStore() {
    exists(CallExpr call |
      call.getStaticTarget().(Method).hasQualifiedName("UserDefaults", "set(_:forKey:)") and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }

  override string getStoreName() { result = "the user defaults database" }
}

/**
 * The `DataFlow::Node` of an expression that gets written to the iCloud-backed `NSUbiquitousKeyValueStore`.
 */
private class NSUbiquitousKeyValueStore extends CleartextStoragePreferencesSink {
  NSUbiquitousKeyValueStore() {
    exists(CallExpr call |
      call.getStaticTarget()
          .(Method)
          .hasQualifiedName("NSUbiquitousKeyValueStore", "set(_:forKey:)") and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }

  override string getStoreName() { result = "iCloud" }
}

/**
 * A more complicated case, this is a macOS-only way of writing to
 * NSUserDefaults by modifying the `NSUserDefaultsController.values: Any`
 * object via reflection (`perform(Selector)`) or the `NSKeyValueCoding`,
 * `NSKeyValueBindingCreation` APIs.
 */
private class NSUserDefaultsControllerStore extends CleartextStoragePreferencesSink {
  NSUserDefaultsControllerStore() {
    none() // not yet implemented
  }

  override string getStoreName() { result = "the user defaults database" }
}

/**
 * A barrier for cleartext preferences storage vulnerabilities.
 *  - encryption; encrypted values are not cleartext.
 *  - booleans; these are more likely to be settings, rather than actual sensitive data.
 */
private class CleartextStoragePreferencesDefaultBarrier extends CleartextStoragePreferencesBarrier {
  CleartextStoragePreferencesDefaultBarrier() {
    this.asExpr() instanceof EncryptedExpr or
    this.asExpr().getType().getUnderlyingType() instanceof BoolType
  }
}

/**
 * An additional taint step for cleartext preferences storage vulnerabilities.
 */
private class CleartextStoragePreferencesFieldAdditionalFlowStep extends CleartextStoragePreferencesAdditionalFlowStep
{
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // if an object is sensitive, its fields are always sensitive.
    nodeTo.asExpr().(MemberRefExpr).getBase() = nodeFrom.asExpr()
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCleartextStoragePreferencesSink extends CleartextStoragePreferencesSink {
  DefaultCleartextStoragePreferencesSink() { sinkNode(this, "preferences-store") }

  override string getStoreName() { result = "a preferences store" }
}
