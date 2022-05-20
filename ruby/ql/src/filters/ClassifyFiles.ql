/**
 * @name Classify files
 * @description This query produces a list of all files in a database
 *              that are classified as generated code or test code.
 *
 *              Used by LGTM.
 * @kind file-classifier
 * @id rb/file-classifier
 */

import ruby
import codeql.ruby.filters.GeneratedCode

predicate classify(File f, string category) {
  f instanceof GeneratedCodeFile and category = "generated"
}

from File f, string category
where classify(f, category)
select f, category
