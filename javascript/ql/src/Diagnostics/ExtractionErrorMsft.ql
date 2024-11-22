/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id js/diagnostics/extraction-errors-msft
 */

 import javascript
 
 from Error error
 where
   exists(error.getFile().getRelativePath()) and
   error.isFatal()
 select error.getFile(), error.getMessage()
 