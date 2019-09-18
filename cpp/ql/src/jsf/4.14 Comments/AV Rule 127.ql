/**
 * @name AV Rule 127
 * @description Code that is not used (commented out) shall be deleted.
 * @kind problem
 * @id cpp/jsf/av-rule-127
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.14 Comments/AV Rule 127.ql"
select d, d.getMessage()
