/**
 * Provides classes for dealing with semantic versions, for dependency versions.
 */
overlay[local?]
module;

import semmle.go.dependencies.Dependencies
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
    this = dep.getDepVersion() and
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

/**
 * A version string in a dependency that has a SemVer, but also contains a git commit SHA.
 *
 * This class is useful for interacting with go.mod versions, which use SemVer, but can also contain
 * SHAs if no useful tags are found, or when a user wishes to specify a commit SHA.
 *
 * Pre-release information and build metadata is not yet supported.
 */
class DependencySemShaVersion extends DependencySemVer {
  string sha;

  DependencySemShaVersion() { sha = this.regexpCapture(".*-([0-9a-f]+)", 1) }

  /**
   * Gets the commit SHA associated with this version.
   */
  string getSha() { result = sha }

  bindingset[other]
  override predicate is(string other) {
    this.getSha() = other.(DependencySemShaVersion).getSha()
    or
    not other instanceof DependencySemShaVersion and
    super.is(other)
  }
}
