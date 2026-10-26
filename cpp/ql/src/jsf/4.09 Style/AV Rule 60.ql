/**
 * @name AV Rule 60
 * @description Braces which enclose a block will be placed in the same column, on separate lines directly before and after the block.
 * @kind problem
 * @id cpp/jsf/av-rule-60
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.09 Style/AV Rule 60.ql"
select d, d.getMessage()
