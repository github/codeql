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
  string getPath() {
    exists(string fullPath | packages(this, _, fullPath, _) |
      result = fullPath.regexpReplaceAll("^.*/vendor/", "")
    )
  }

  /** Gets the scope of this package. */
  PackageScope getScope() { packages(this, _, _, result) }

  /** Gets a textual representation of this element. */
  string toString() { result = "package " + getPath() }
}

/**
 * Gets the Go import string that may identify a package in module `mod` with the given path,
 * possibly modulo semantic import versioning.
 */
bindingset[result, mod, path]
string package(string mod, string path) {
  result.regexpMatch("\\Q" + mod + "\\E([/.]v[^/]+)?/\\Q" + path + "\\E")
}
