/**
 * @id rust/summary/number-of-files-extracted-with-errors
 * @name Total number of Rust files that were extracted with errors
 * @description The total number of Rust code files that we extracted, but where
 *  at least one extraction error occurred in the process.
 * @kind metric
 * @tags summary
 */

import codeql.files.FileSystem
import codeql.rust.Diagnostics

select count(File f |
    exists(ExtractionError e | e.getLocation().getFile() = f) and exists(f.getRelativePath())
  )
