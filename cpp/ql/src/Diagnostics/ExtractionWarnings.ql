/**
 * @name Extraction warnings
 * @description List all extraction warnings for files in the source code directory.
 * @kind diagnostic
 * @id cpp/diagnostics/extraction-warnings
 */

import cpp
import ExtractionProblems

from ExtractionProblem warning
where
  warning instanceof ExtractionRecoverableWarning and
  exists(warning.getFile().getRelativePath()) and
  not warning.getCompilation().buildModeNone()
  or
  warning instanceof ExtractionUnknownProblem
select warning,
  "Extraction failed in " + warning.getFile() + " with warning " +
    warning.getProblemMessage().replaceAll("$", "$$"), warning.getSeverity()
