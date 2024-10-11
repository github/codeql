/**
 * @id rb/summary/number-of-files-extracted-with-errors
 * @name Total number of Ruby files that were extracted with errors
 * @description The total number of Ruby code files that we extracted, but where
 *  at least one extraction error (or warning) occurred in the process.
 * @kind metric
 * @tags summary
 */

import codeql.ruby.AST
import codeql.files.FileSystem

select count(File f |
    exists(f.getRelativePath()) and
    not f instanceof SuccessfullyExtractedFile
  )
