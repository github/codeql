/**
 * @name AV Rule 9
 * @description Only those characters specified in the C++ basic source character set will be used.
 * @kind problem
 * @id cpp/jsf/av-rule-9
 * @problem.severity warning
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.04 Environment/AV Rule 9.ql"
select d, d.getMessage()
