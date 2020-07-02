/**
 * Helpers to generating meta metrics, that is, metrics about the CodeQL analysis and extractor.
 */

private import javascript
private import semmle.javascript.dependencies.Dependencies
private import semmle.javascript.dependencies.FrameworkLibraries
private import semmle.javascript.frameworks.Testing

/**
 * Gets the root folder of the snapshot.
 *
 * This is selected as the location for project-wide metrics.
 */
Folder projectRoot() { result.getRelativePath() = "" }

/** A file we ignore because it is a test file or compiled/generated/bundled code. */
class IgnoredFile extends File {
  IgnoredFile() {
    any(Test t).getFile() = this
    or
    getRelativePath().regexpMatch("(?i).*/test(case)?s?/.*")
    or
    getBaseName().regexpMatch("(?i)(.*[._\\-]|^)(min|bundle|concat|spec|tests?)\\.[a-zA-Z]+")
    or
    exists(TopLevel tl | tl.getFile() = this |
      tl.isExterns()
      or
      tl instanceof FrameworkLibraryInstance
    )
  }
}
