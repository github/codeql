/**
 * Provides predicates to guess whether the codebase is an application or a gem.
 */

private import ruby

/**
 * Provides predicates to guess whether the codebase is an application or a gem.
 */
module Application {
  /**
   * Holds if the codebase has a .gemspec file.
   * This indicates it is a gem, or contains a gem.
   */
  private predicate hasGemspec() { exists(File f | f.getExtension() = "gemspec") }

  /**
   * Holds if the codebase has a Gemfile.
   */
  private predicate hasGemfile() { exists(File f | f.getBaseName() = "Gemfile") }

  /**
   * Holds if the codebase has a Gemfile.lock
   * This indicates it is probably an application (though some gems erroneously have this file, too).
   */
  private predicate hasGemfileLock() { exists(File f | f.getBaseName() = "Gemfile.lock") }

  /**
   * Holds if the codebase is likely to be a gem.
   * This is a heuristic, so may be wrong.
   * In particular, it will be confused by applications that contain vendored gems.
   */
  predicate isGem() {
    hasGemspec()
    or
    hasGemfile() and not hasGemfileLock()
  }
}
