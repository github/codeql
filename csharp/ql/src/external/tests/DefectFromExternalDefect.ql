/**
 * @name Defect from external defect
 * @description Create a defect from external data
 * @kind problem
 * @problem.severity warning
 * @deprecated
 */

import csharp
import external.ExternalArtifact

class DuplicateCode extends ExternalDefect {
  DuplicateCode() { getQueryPath() = "duplicate-code/duplicateCode.ql" }
}

from DuplicateCode d
select d, "External Defect " + d.getMessage()
