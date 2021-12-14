/**
 * @name AV Rule 200
 * @description Null initialize or increment expressions in for loops will not be used;
 *              a while loop will be used instead.
 * @kind problem
 * @id cpp/jsf/av-rule-200
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

from ForStmt f
where
  f.fromSource() and
  (not exists(f.getInitialization()) or not exists(f.getUpdate()))
select f, "AV Rule 200: Every for loop will have non-null initialize and increment expressions."
