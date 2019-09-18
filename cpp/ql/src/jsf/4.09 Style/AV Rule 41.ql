/**
 * @name AV Rule 41
 * @description Source lines will be kept to a length of 120 characters or less.
 * @kind problem
 * @id cpp/jsf/av-rule-41
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.09 Style/AV Rule 41.ql"
select d, d.getMessage()
