/**
 * @name AV Rule 43
 * @description Tabs should be avoided.
 * @kind problem
 * @id cpp/jsf/av-rule-43
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.09 Style/AV Rule 43.ql"
select d, d.getMessage()
