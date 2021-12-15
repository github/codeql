/**
 * @name Extraction errors
 * @description A list of extraction errors for files in the source code directory.
 * @kind diagnostic
 * @id java/diagnostics/extraction-errors
 */

import java
import DiagnosticsReporting

from string msg, int sev
where reportableErrors(_, msg, sev)
select msg, sev
