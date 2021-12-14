/**
 * @name AV Rule 11
 * @description Trigraphs will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-11
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import external.ExternalArtifact

from DefectExternalData d
where d.getQueryPath() = "jsf/4.04 Environment/AV Rule 11.ql"
select d, d.getMessage()
