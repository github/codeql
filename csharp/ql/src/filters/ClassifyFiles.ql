/**
 * @name Classify files
 * @description This query produces a list of all files in a snapshot
 *              that are classified as generated code or test code.
 * @kind file-classifier
 * @id cs/file-classifier
 */

import csharp
import semmle.code.csharp.commons.GeneratedCode
import semmle.code.csharp.frameworks.Test

predicate classify(File f, string category) {
  f instanceof GeneratedCodeFile and category = "generated"
  or
  f instanceof TestFile and category = "test"
}

from File f, string category
where classify(f, category)
select f, category
