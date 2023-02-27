/**
 * Provides classes and predicates for reasoning about cleartext preferences
 * storage vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A `DataFlow::Node` of something that gets stored in an application preference store.
 */
abstract class Stored extends DataFlow::Node {
  abstract string getStoreName();
}

/** The `DataFlow::Node` of an expression that gets written to the user defaults database */
class UserDefaultsStore extends Stored {
  UserDefaultsStore() {
    exists(CallExpr call |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("UserDefaults", "set(_:forKey:)") and
      call.getArgument(0).getExpr() = this.asExpr()
    )
  }

  override string getStoreName() { result = "the user defaults database" }
}

/** The `DataFlow::Node` of an expression that gets written to the iCloud-backed NSUbiquitousKeyValueStore */
class NSUbiquitousKeyValueStore extends Stored {
  NSUbiquitousKeyValueStore() {
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
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
 * `NSKeyValueBindingCreation` APIs. (TODO)
 */
class NSUserDefaultsControllerStore extends Stored {
  NSUserDefaultsControllerStore() { none() }

  override string getStoreName() { result = "the user defaults database" }
}
