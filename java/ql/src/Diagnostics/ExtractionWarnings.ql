/**
 * @name Extraction warnings
 * @description A list of extraction warnings for files in the source code directory.
 * @kind diagnostic
 * @id java/diagnostics/extraction-warnings
 */

import java
import DiagnosticsReporting

from string msg, int sev
where reportableWarnings(_, msg, sev)
select msg, sev
