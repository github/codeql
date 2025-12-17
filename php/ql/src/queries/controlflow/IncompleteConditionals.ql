/**
 * @name Incomplete Conditional Coverage
 * @description Detects if/elseif statements without else branch that might miss execution paths.
 * @kind problem
 * @problem.severity note
 * @id php/incomplete-conditionals
 * @tags maintainability
 *       controlflow
 */

import php
import codeql.php.EnhancedControlFlow

from ConditionalChain cond
where
  // Has at least one elseif clause but no else
  exists(cond.getAnElseIfClause()) and
  not cond.hasElse()
select cond.getIfBody(),
       "Conditional with multiple branches (elseif) is missing a final else case."
