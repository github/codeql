/**
 * Provides classes for working with file system paths and program expressions
 * that denote them.
 */

import minimal

/**
 * Gets a regular expression that can be used to parse slash-separated paths.
 *
 * The first capture group captures the dirname of the path, that is, everything
 * before the last slash, or the empty string if there isn't a slash.
 *
 * The second capture group captures the basename of the path, that is, everything
 * after the last slash, or the entire path if there isn't a slash.
 *
 * The third capture group captures the stem of the basename, that is, everything
 * before the last dot, or the entire basename if there isn't a dot.
 *
 * Finally, the fourth and fifth capture groups capture the extension of the basename,
 * that is, everything after the last dot. The fourth group includes the dot, the
 * fifth does not.
 */
private string pathRegex() { result = "(.*)(?:/|^)(([^/]*?)(\\.([^.]*))?)" }

/**
 * A `string` with some additional member predicates for extracting parts of a file path.
 */
class FilePath extends string {
  bindingset[this]
  FilePath() { any() }

  /** Gets the `i`th component of this path. */
  bindingset[this]
  string getComponent(int i) { result = this.splitAt("/", i) }

  /** Gets the number of components of this path. */
  bindingset[this]
  int getNumComponent() { result = count(int i | exists(this.getComponent(i))) }

  /** Gets the base name of the folder or file this path refers to. */
  bindingset[this]
  string getBaseName() { result = this.regexpCapture(pathRegex(), 2) }

  /**
   * Gets stem of the folder or file this path refers to, that is, the prefix of its base name
   * up to (but not including) the last dot character if there is one, or the entire
   * base name if there is not
   */
  bindingset[this]
  string getStem() { result = this.regexpCapture(pathRegex(), 3) }

  /** Gets the path of the parent folder of the folder or file this path refers to. */
  bindingset[this]
  string getDirName() { result = this.regexpCapture(pathRegex(), 1) }

  /**
   * Gets the extension of the folder or file this path refers to, that is, the suffix of the base name
   * starting at the last dot character, if there is one.
   *
   * Has no result if the base name does not contain a dot.
   */
  bindingset[this]
  string getExtension() { result = this.regexpCapture(pathRegex(), 4) }

  /**
   * Holds if this is a relative path starting with an explicit `./` or similar syntax meaning it
   * must be resolved relative to its enclosing folder.
   *
   * Specifically this holds when the string is `.` or `..`, or starts with `./` or `../` or
   * `.\` or `..\`.
   */
  bindingset[this]
  pragma[inline_late]
  predicate isDotRelativePath() { this.regexpMatch("\\.\\.?(?:[/\\\\].*)?") }

  /**
   * Gets the NPM package name from the beginning of the given import path.
   *
   * Has no result for paths starting with a `.` or `/`
   *
   * For example:
   * - `foo/bar` maps to `foo`
   * - `@example/foo/bar` maps to `@example/foo`
   * - `./foo` maps to nothing.
   */
  bindingset[this]
  string getPackagePrefix() {
    result = this.regexpFind("^(@[^/\\\\]+[/\\\\])?[^@./\\\\][^/\\\\]*", _, _)
  }
}
