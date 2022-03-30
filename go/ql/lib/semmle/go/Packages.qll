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
 * Gets an import path that identifies a package in module `mod` with the given path,
 * possibly modulo [semantic import versioning](https://github.com/golang/go/wiki/Modules#semantic-import-versioning).
 *
 * For example, `package("github.com/go-pg/pg", "types")` gets an import path that can
 * refer to `"github.com/go-pg/pg/types"`, but also to `"github.com/go-pg/pg/v10/types"`.
 */
bindingset[mod, path]
string package(string mod, string path) {
  // "\Q" and "\E" start and end a quoted section of a regular expression. Anything like "." or "*" that
  // "*" that comes between them is not interpreted as it would normally be in a regular expression.
  result.regexpMatch("\\Q" + mod + "\\E([/.]v[^/]+)?($|/)\\Q" + path + "\\E") and
  result = any(Package p).getPath()
}
