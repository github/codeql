/**
 * @name AV Rule 33
 * @description The #include directive shall use the <filename.h> notation to include header files.
 * @kind problem
 * @id cpp/jsf/av-rule-33
 * @problem.severity error
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp

from Include i
where i.getIncludeText().matches("<%")
select i, "AV Rule 33: the #include <filename.h> notation shall be used."
