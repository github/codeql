/**
 * @name Classify files
 * @description This query produces a list of all files in a snapshot
 *              that are classified as generated code or test code.
 * @kind file-classifier
 * @id java/file-classifier
 */

import java

predicate classify(File f, string tag) {
  f instanceof GeneratedFile and tag = "generated"
  or
  exists(GeneratedClass gc | gc.getFile() = f | tag = "generated")
  or
  exists(TestClass tc | tc.getFile() = f | tag = "test")
  or
  exists(TestMethod tm | tm.getFile() = f | tag = "test")
}

from File f, string tag
where classify(f, tag)
select f, tag
