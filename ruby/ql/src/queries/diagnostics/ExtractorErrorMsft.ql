/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @id rb/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import codeql.ruby.AST
 import codeql.ruby.Diagnostics
 
 from ExtractionError error, File f
 where
   f = error.getLocation().getFile() and
   exists(f.getRelativePath())
 select f, error.getMessage()
 