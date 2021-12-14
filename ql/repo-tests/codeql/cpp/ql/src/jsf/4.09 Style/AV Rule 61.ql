/**
 * @name AV Rule 61
 * @description Braces which enclose a block will have nothing else on the line except comments (if necessary).
 * @kind problem
 * @id cpp/jsf/av-rule-61
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.09 Style/AV Rule 61.ql"
select d, d.getMessage()
