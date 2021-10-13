/**
 * @name AV Rule 21
 * @description The signal handling facilities of <signal.h> shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-21
 * @problem.severity error
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

from Include incl
where incl.getIncludedFile().getAbsolutePath().matches("%signal.h")
select incl, "AV Rule 21: The signal handling facilities of <signal.h> shall not be used."
