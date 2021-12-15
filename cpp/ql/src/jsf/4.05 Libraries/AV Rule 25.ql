/**
 * @name AV Rule 25
 * @description The time handling functions of library <time.h> shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-25
 * @problem.severity error
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

from Include incl
where incl.getIncludedFile().getAbsolutePath().matches("%time.h")
select incl, "AV Rule 25: The time handling functions of library <time.h> shall not be used."
