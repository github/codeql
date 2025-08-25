/**
 * @id rb/summary/number-of-successfully-extracted-files
 * @name Total number of Ruby files that were extracted without error
 * @description The total number of Ruby code files that we extracted without
 *   encountering any extraction errors (or warnings).
 * @kind metric
 * @tags summary
 */

import codeql.ruby.AST
import codeql.files.FileSystem

select count(SuccessfullyExtractedFile f | exists(f.getRelativePath()))
