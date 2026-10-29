/**
 * @name AV Rule 12
 * @description Digraphs will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-12
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.04 Environment/AV Rule 12.ql"
select d, d.getMessage()
