/**
 * @name Classify files
 * @description This query produces a list of all files in a snapshot
 *              that are classified as generated code or test code.
 * @kind file-classifier
 * @id py/file-classifier
 */

import python
import semmle.python.filters.GeneratedCode
import semmle.python.filters.Tests

predicate classify(File f, string tag) {
  f instanceof GeneratedFile and tag = "generated"
  or
  exists(TestScope t | t.getLocation().getFile() = f) and tag = "test"
}

from File f, string tag
where classify(f, tag)
select f, tag
