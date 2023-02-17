/**
 * Provides classes for modeling go.mod dependencies.
 */

import go

/**
 * An abstract representation of a dependency.
 */
abstract class Dependency extends Locatable {
  /**
   * Holds if this dependency has package path `path` and version `v`.
   *
   * If the version cannot be determined, `v` is bound to the string
   * `"unknown"`.
   */
  abstract predicate info(string path, string v);

  /** Gets the package path of this dependency. */
  string getDepPath() { this.info(result, _) }

  /** Gets the version of this dependency. */
  string getDepVersion() { this.info(_, result) }

  /**
   * Holds if this dependency is relevant for imports in file `file`. That is, an import of this
   * dependency's path that is in `file` will use this dependency.
   */
  abstract predicate relevantForFile(File file);

  /** Gets an import of this dependency. */
  ImportSpec getAnImport() {
    result.getPath().regexpMatch("\\Q" + this.getDepPath() + "\\E(/.*)?") and
    this.relevantForFile(result.getFile())
  }
}

/**
 * A dependency from a go.mod file.
 */
class GoModDependency extends Dependency, GoModRequireLine {
  override predicate info(string path, string v) {
    this.replacementInfo(path, v)
    or
    not this.replacementInfo(_, _) and
    this.originalInfo(path, v)
  }

  override predicate relevantForFile(File file) {
    exists(Folder parent | parent.getAFile() = this.getFile() |
      parent.getAFolder*().getAFile() = file
    )
  }

  /**
   * Holds if there is a replace line that replaces this dependency with a dependency on `path`,
   * version `v`.
   */
  predicate replacementInfo(string path, string v) {
    exists(GoModReplaceLine replace |
      replace.getFile() = this.getFile() and
      replace.getOriginalPath() = this.getPath()
    |
      path = replace.getReplacementPath() and
      (
        v = replace.getReplacementVersion()
        or
        not exists(replace.getReplacementVersion()) and
        v = "unknown"
      )
    )
  }

  /**
   * Get a version that was excluded for this dependency.
   */
  string getAnExcludedVersion() {
    exists(GoModExcludeLine exclude |
      exclude.getFile() = this.getFile() and
      exclude.getPath() = this.getPath()
    |
      result = exclude.getVersion()
    )
  }

  /**
   * Holds if this require line originally states dependency `path` had version `v`.
   *
   * The actual info of this dependency can change based on `replace` directives in the same go.mod
   * file, which replace a dependency with another one.
   */
  predicate originalInfo(string path, string v) { path = this.getPath() and v = this.getVersion() }
}
