/**
 * @id rust/summary/number-of-files-extracted-with-errors
 * @name Total number of Rust files that were extracted with errors
 * @description The total number of Rust files in the source code directory that
 *  were extracted, but where at least one extraction error (or warning) occurred
 *  in the process.
 * @kind metric
 * @tags summary
 */

import codeql.files.FileSystem

select count(File f |
    exists(f.getRelativePath()) and
    not f instanceof SuccessfullyExtractedFile
  )
