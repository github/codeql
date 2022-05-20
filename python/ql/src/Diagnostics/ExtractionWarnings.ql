/**
 * @name Python extraction warnings
 * @description List all extraction warnings for Python files in the source code directory.
 * @kind diagnostic
 * @id py/diagnostics/extraction-warnings
 */

import python

/**
 * Gets the SARIF severity for warnings.
 *
 * See https://docs.oasis-open.org/sarif/sarif/v2.1.0/csprd01/sarif-v2.1.0-csprd01.html#_Toc10541338
 */
int getWarningSeverity() { result = 1 }

// The spec
// https://docs.oasis-open.org/sarif/sarif/v2.1.0/csprd01/sarif-v2.1.0-csprd01.html#_Toc10541338
// defines error and warning as:
//
// "error": A serious problem was found. The condition encountered by the tool resulted
// in the analysis being halted or caused the results to be incorrect or incomplete.
//
// "warning": A problem that is not considered serious was found. The condition
// encountered by the tool is such that it is uncertain whether a problem occurred, or
// is such that the analysis might be incomplete but the results that were generated are
// probably valid.
//
// So SyntaxErrors are reported at the warning level, since analysis might be incomplete
// but the results that were generated are probably valid.
from SyntaxError error, File file
where
  file = error.getFile() and
  exists(file.getRelativePath())
select error, "Extraction failed in " + file + " with error " + error.getMessage(),
  getWarningSeverity()
