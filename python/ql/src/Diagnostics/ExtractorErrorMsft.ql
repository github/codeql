/**
 * @name Python extraction warnings msft
 * @description List all extraction warnings for Python files in the source code directory.
 * @kind diagnostic
 * @id py/diagnostics/extraction-warnings-msft
 */

 import python

 from SyntaxError error, File file
 where
   file = error.getFile() and
   exists(file.getRelativePath())
 select file, error.getMessage()
 