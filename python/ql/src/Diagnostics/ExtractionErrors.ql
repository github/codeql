/**
 * @name Python extraction errors
 * @description List all extraction errors for Python files in the source code directory.
 * @kind diagnostic
 * @id py/diagnostics/extraction-errors
 */

import python

/**
 * Gets the SARIF severity for errors.
 *
 * See point 3.27.10 in https://docs.oasis-open.org/sarif/sarif/v2.0/sarif-v2.0.html for
 * what error means.
 */
int getErrorSeverity() { result = 2 }

from SyntaxError error, File file
where
  file = error.getFile() and
  exists(file.getRelativePath())
select error, "Extraction failed in " + file + " with error " + error.getMessage(),
  getErrorSeverity()
