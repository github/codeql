/**
 * @name AV Rule 108
 * @description Functions with variable number of arguments shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-108
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

from Function f
where f.fromSource() and f.hasSpecifier("varargs")
select f, "AV Rule 108: Functions with variable number of arguments shall not be used."
