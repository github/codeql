/**
 * @name AV Rule 208
 * @description C++ exceptions shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-208
 * @problem.severity recommendation
 * @tags language-features
 *       external/jsf
 */

import cpp

from Element e
where e instanceof TryStmt or e instanceof ThrowExpr
select e, "AV Rule 208: C++ exceptions shall not be used."
