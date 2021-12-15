/**
 * @name AV Rule 153
 * @description Unions shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-153
 * @problem.severity recommendation
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * See MISRA Rule 9-5-1
 */

from Union u
where u.fromSource()
select u, "AV Rule 153: Unions shall not be used."
