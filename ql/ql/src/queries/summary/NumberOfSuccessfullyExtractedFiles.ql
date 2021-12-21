/**
 * @id ql/summary/number-of-successfully-extracted-files
 * @name Total number of files that were extracted without error
 * @description The total number of QL code files that we extracted without
 *   encountering any extraction errors
 * @kind metric
 * @tags summary
 */

import ql
import codeql_ql.Diagnostics

select count(File f |
    not exists(ExtractionError e | e.getLocation().getFile() = f) and exists(f.getRelativePath())
  )
