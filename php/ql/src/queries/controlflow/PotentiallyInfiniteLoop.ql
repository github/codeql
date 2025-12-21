/**
 * @name Potentially Infinite Loop
 * @description Detects loops that might not terminate (infinite loops).
 * @kind problem
 * @problem.severity warning
 * @id php/infinite-loop
 * @tags correctness
 *       deadcode
 */

import php
import codeql.php.EnhancedControlFlow
private import codeql.php.ast.internal.TreeSitter as TS

/**
 * Checks if a loop condition is the literal 'true' or '1'.
 */
predicate isAlwaysTrueCondition(TS::PHP::AstNode condition) {
  condition.(TS::PHP::Boolean).getValue() = "true" or
  condition.(TS::PHP::Integer).getValue() = "1"
}

/**
 * Checks if a loop body contains a break statement.
 */
predicate hasBreakStatement(TS::PHP::AstNode body) {
  exists(TS::PHP::BreakStatement b | b.getParent*() = body)
}

from EnhancedLoopNode loop, TS::PHP::AstNode condition, TS::PHP::AstNode body
where
  condition = loop.getLoopCondition() and
  body = loop.getLoopBody() and
  isAlwaysTrueCondition(condition) and
  not hasBreakStatement(body)
select loop,
       "This loop may be infinite - condition is always true and no break statement found."
