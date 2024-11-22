/**
 * @name Extraction errors msft
 * @description List all extraction errors for files in the source code directory.
 * @id js/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import javascript
 
 from Error error
 where
   exists(error.getFile().getRelativePath()) and
   error.isFatal()
 select error.getFile(), error.getMessage()
 