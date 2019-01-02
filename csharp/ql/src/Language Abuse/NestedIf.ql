/**
 * @name Nested 'if' statements can be combined
 * @description Nested 'if' statements can be simplified by combining them using '&&'.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/nested-if-statements
 * @tags maintainability
 *       language-features
 */

import csharp

from IfStmt outer, IfStmt inner
where
  inner = outer.getThen().stripSingletonBlocks() and
  not exists(outer.getElse()) and
  not exists(inner.getElse())
select outer, "These 'if' statements can be combined."
