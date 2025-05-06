/**
 * Provides an extensible mechanism for modeling path mappings.
 */

private import javascript
private import semmle.javascript.TSConfig

/**
 * A `tsconfig.json`-like configuration object that can affect import resolution via path mappings.
 */
abstract class PathMapping extends Locatable {
  /**
   * Gets a file affected by this path mapping.
   */
  abstract File getAnAffectedFile();

  /**
   * Holds if imports paths exactly matching `pattern` should be redirected to `newPath`
   * resolved relative to `newContext`.
   */
  predicate hasExactPathMapping(string pattern, Container newContext, string newPath) { none() }

  /**
   * Holds if imports paths starting with `pattern` should have the matched prefix replaced by `newPath`
   * and then resolved relative to `newContext`.
   */
  predicate hasPrefixPathMapping(string pattern, Container newContext, string newPath) { none() }

  /** Holds if non-relative paths in affected files should be resolved relative to `base`. */
  predicate hasBaseUrl(Container base) { none() }
}
