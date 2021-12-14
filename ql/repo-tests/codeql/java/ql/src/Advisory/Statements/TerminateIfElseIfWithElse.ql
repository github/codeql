/**
 * @name Non-terminated if-else-if chain
 * @description An 'if-else-if' statement without a terminating 'else' clause may allow execution to
 *              'fall through' silently.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/non-terminated-if-else-if-chain
 * @tags reliability
 */

import java

from IfStmt prev, IfStmt last
where
  not exists(last.getElse()) and
  prev.getElse() = last
select last, "If-else-if statement does not have a terminating else statement."
