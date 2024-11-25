/**
 * @name Python extraction warnings msft
 * @description List all extraction warnings for Python files in the source code directory.
 * @id py/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import python

 from SyntaxError error, File file
 where
   file = error.getFile() and
   exists(file.getRelativePath())
 select file, error.getMessage()
 