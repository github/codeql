/**
 * Provides classes and predicates for working with Java packages.
 */

import Element
import Type
import metrics.MetricPackage

/**
 * A package may be used to abstract over all of its members,
 * regardless of which compilation unit they are defined in.
 */
class Package extends Element, Annotatable, @package {
  /** Gets a top level type in this package. */
  TopLevelType getATopLevelType() { result.getPackage() = this }

  /** Holds if at least one reference type in this package originates from source code. */
  override predicate fromSource() { exists(RefType t | t.fromSource() and t.getPackage() = this) }

  /** Cast this package to a class that provides access to metrics information. */
  MetricPackage getMetrics() { result = this }

  /**
   * A dummy URL for packages.
   *
   * This declaration is required to allow selection of packages in QL queries.
   * Without it, an implicit call to `Package.getLocation()` would be generated
   * when selecting a package, which would result in a compile-time error
   * since packages do not have locations.
   */
  string getURL() { result = "file://:0:0:0:0" }
}
