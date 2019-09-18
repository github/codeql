/**
 * @name Poor error handling: empty catch block
 * @description Finds catch clauses with an empty block
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cs/empty-catch-block
 * @tags reliability
 *       readability
 *       exceptions
 *       external/cwe/cwe-390
 *       external/cwe/cwe-391
 */

import csharp

from CatchClause cc
where
  cc.getBlock().isEmpty() and
  not exists(CommentBlock cb | cb.getParent() = cc.getBlock())
select cc, "Poor error handling: empty catch block."
