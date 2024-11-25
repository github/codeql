/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @id rust/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import codeql.rust.Diagnostics
 import codeql.files.FileSystem
 
 from ExtractionError error, File f
 where
   f = error.getLocation().getFile() and
   exists(f.getRelativePath())
 select f, error.getMessage()

 