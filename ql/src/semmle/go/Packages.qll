/**
 * Provides classes for working with packages.
 */

import go

/**
 * A package.
 */
class Package extends @package {
  /** Gets the name of this package. */
  string getName() { packages(this, result, _, _) }

  /** Gets the path of this package. */
  string getPath() { packages(this, _, result, _) }

  /** Gets the scope of this package. */
  PackageScope getScope() { packages(this, _, _, result) }

  /** Gets a textual representation of this element. */
  string toString() { result = "package " + getPath() }
}
