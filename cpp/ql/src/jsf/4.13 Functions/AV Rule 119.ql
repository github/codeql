/**
 * @name AV Rule 119
 * @description Functions shall not call themselves, either directly or indirectly (i.e. recursion shall not be allowed).
 * @kind problem
 * @id cpp/jsf/av-rule-119
 * @problem.severity recommendation
 * @tags resources
 *       external/jsf
 */

import cpp

from Function f
where
  f.fromSource() and
  f.calls+(f)
select f, "Functions shall not call theselves, either directly or indirectly"
