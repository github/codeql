/**
 * @name Compiler errors
 * @description List all compiler errors for files in the source code directory.
 * @kind diagnostic
 * @id swift/diagnostics/extraction-errors
 */

import swift

from CompilerError error
select error, "Compiler error in " + error.getFile() + " with error message " + error.getText()
