/**
 * @name Compiler errors msft
 * @description List all compiler errors for files in the source code directory.
 * @id swift/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import swift

 from CompilerError error
 select error.getFile(), error.getText()
 