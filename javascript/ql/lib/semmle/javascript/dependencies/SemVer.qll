/**
 * Provides classes for working SemVer (Semantic Versioning).
 */

import semmle.javascript.dependencies.Dependencies
private import codeql.util.SemVer

/**
 * A SemVer-formatted version string in a dependency.
 *
 * Pre-release information and build metadata is not yet supported.
 */
class DependencySemVer extends string {
  Dependency dep;
  string normalized;

  DependencySemVer() {
    dep.info(_, this) and
    normalized = normalizeSemVer(this)
  }

  /**
   * Holds if this version may be before `last`.
   */
  bindingset[last]
  predicate maybeBefore(string last) { normalized < normalizeSemVer(last) }

  /**
   * Holds if this version may be after `first`.
   */
  bindingset[first]
  predicate maybeAfter(string first) { normalizeSemVer(first) < normalized }

  /**
   * Holds if this version may be between `first` (inclusive) and `last` (exclusive).
   */
  bindingset[first, last]
  predicate maybeBetween(string first, string last) {
    normalizeSemVer(first) <= normalized and
    normalized < normalizeSemVer(last)
  }

  /**
   * Holds if this version is equivalent to `other`.
   */
  bindingset[other]
  predicate is(string other) { normalized = normalizeSemVer(other) }

  /**
   * Gets the dependency that uses this string.
   */
  Dependency getDependency() { result = dep }
}
