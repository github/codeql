/**
 * @id rb/summary/number-of-successfully-extracted-files
 * @name Total number of Ruby files that were extracted without error
 * @description The total number of Ruby code files that we extracted without
 *   encountering any extraction errors
 * @kind metric
 * @tags summary
 */

import codeql.ruby.AST
import codeql.ruby.Diagnostics

select count(File f |
    not exists(ExtractionError e | e.getLocation().getFile() = f) and exists(f.getRelativePath())
  )
