/**
 * @name Extracted files
 * @description Lists all files in the source code directory that were extracted.
 * @kind diagnostic
 * @id rb/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import codeql.ruby.AST
import codeql.ruby.Diagnostics

from File f
where exists(f.getRelativePath())
select f, ""
