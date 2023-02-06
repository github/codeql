/**
 * @name Classify files
 * @description This query produces a list of all files in a snapshot that are classified as
 *              generated code, test code or vendored-in library code.
 * @kind file-classifier
 * @id go/file-classifier
 */

import go

predicate classify(File f, string category) {
  // tests
  f instanceof TestFile and
  category = "test"
  or
  // vendored code
  f.getRelativePath().regexpMatch(".*/vendor/.*") and
  category = "library"
  or
  // generated code
  f instanceof GeneratedFile and
  category = "generated"
}

from File f, string category
where classify(f, category)
select f, category
