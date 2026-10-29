/**
 * @name AV Rule 19
 * @description <locale.h> and the setlocale function shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-19
 * @problem.severity error
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Include incl
where incl.getIncludedFile().getAbsolutePath().matches("%locale.h")
select incl, "AV Rule 19: <locale.h> and the setlocale function shall not be used."
