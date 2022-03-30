/**
 * @name AV Rule 126
 * @description Only valid C++ style comments shall be used.
 * @kind problem
 * @id cpp/jsf/av-rule-126
 * @problem.severity recommendation
 * @tags maintainability
 *       documentation
 *       external/jsf
 */

import cpp

from Comment c
where
  c.fromSource() and
  not c.getContents().regexpMatch("\\s*//.*")
select c, "AV Rule 126: Only valid C++ style comments shall be used."
