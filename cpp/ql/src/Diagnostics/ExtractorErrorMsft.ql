/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id cpp/diagnostics/extraction-errors
 */

 import cpp
 import ExtractionErrors
 
 from ExtractionError error
 select error.getFile(), error.getErrorMessage()

 