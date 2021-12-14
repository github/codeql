/**
 * @name AV Rule 22
 * @description The input/output library <stdio.h> shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-22
 * @problem.severity error
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp

from Include incl
where incl.getIncludedFile().getAbsolutePath().matches("%stdio.h")
select incl, "AV Rule 22: The input/output library <stdio.h> shall not be used."
