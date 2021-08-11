/**
 * @id rb/summary/number-of-files-extracted-with-errors
 * @name Total number of files that were extracted with errors
 * @description The total number of Ruby code files that we extracted, but where
 *  at least one extraction error occurred in the process.
 * @kind metric
 * @tags summary
 */

import ruby
import codeql.ruby.Diagnostics

select count(File f |
    exists(ExtractionError e | e.getLocation().getFile() = f) and exists(f.getRelativePath())
  )
