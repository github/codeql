/**
 * Helpers for generating meta metrics, that is, metrics about the CodeQL analysis and extractor.
 */

import python
private import semmle.python.filters.GeneratedCode
private import semmle.python.filters.Tests

/**
 * Gets the root folder of the snapshot.
 *
 * This is selected as the location for project-wide metrics.
 */
Folder projectRoot() { result.getRelativePath() = "" }

/** A file we ignore because it is a test file, part of a third-party library, or compiled/generated/bundled code. */
class IgnoredFile extends File {
  IgnoredFile() {
    any(TestScope ts).getLocation().getFile() = this
    or
    this instanceof GeneratedFile
    or
    // outside source root (inspired by `Scope.inSource`)
    not exists(this.getRelativePath())
  }
}
