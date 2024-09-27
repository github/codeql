/**
 * @id rust/summary/number-of-successfully-extracted-files
 * @name Total number of Rust files that were extracted without error
 * @description The total number of Rust files in the source code directory that
 *  were extracted without encountering any extraction errors.
 * @kind metric
 * @tags summary
 */

import codeql.rust.Diagnostics
import codeql.files.FileSystem

select count(File f |
    not exists(ExtractionError e | e.getLocation().getFile() = f) and exists(f.getRelativePath())
  )
