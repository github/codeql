/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id rust/diagnostics/extraction-errors-msft
 */

 import codeql.rust.Diagnostics
 import codeql.files.FileSystem
 
 from ExtractionError error, File f
 where
   f = error.getLocation().getFile() and
   exists(f.getRelativePath())
 select f, error.getMessage()

 