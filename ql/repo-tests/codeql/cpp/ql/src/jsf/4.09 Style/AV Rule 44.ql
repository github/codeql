/**
 * @name AV Rule 44
 * @description All indentations will be at least two spaces and be consistent within the same source file.
 * @kind problem
 * @id cpp/jsf/av-rule-44
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.09 Style/AV Rule 44.ql"
select d, d.getMessage()
