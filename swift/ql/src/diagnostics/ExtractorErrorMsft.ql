/**
 * @name Compiler errors msft
 * @description List all compiler errors for files in the source code directory.
 * @kind diagnostic
 * @id swift/diagnostics/extraction-errors-msft
 */

 import swift

 from CompilerError error
 select error.getFile(), error.getText()
 