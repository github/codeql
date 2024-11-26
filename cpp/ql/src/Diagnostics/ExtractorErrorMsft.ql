/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @id cpp/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import cpp
 import ExtractionErrors
 
 from ExtractionError error
 select error.getFile(), error.getErrorMessage()

 