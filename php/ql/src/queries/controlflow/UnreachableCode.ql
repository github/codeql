/**
 * @name Unreachable Code
 * @description Detects code that can never be executed due to control flow.
 * @kind problem
 * @problem.severity warning
 * @id php/unreachable-code
 * @tags maintainability
 *       deadcode
 */

import php
import codeql.php.EnhancedControlFlow
private import codeql.php.ast.internal.TreeSitter as TS

/**
 * Checks if a statement is a return statement.
 */
predicate isTerminatingStatement(TS::PHP::Statement stmt) {
  stmt instanceof TS::PHP::ReturnStatement or
  stmt instanceof TS::PHP::ExitStatement or
  // Throw expression wrapped in expression statement
  exists(TS::PHP::ExpressionStatement exprStmt |
    exprStmt = stmt and
    exprStmt.getChild() instanceof TS::PHP::ThrowExpression
  )
}

from TS::PHP::CompoundStatement block, TS::PHP::Statement terminating, TS::PHP::Statement afterTerminating, int i, int j
where
  terminating = block.getChild(i) and
  isTerminatingStatement(terminating) and
  j > i and
  afterTerminating = block.getChild(j) and
  // Exclude case/default labels
  not afterTerminating.getAPrimaryQlClass() = "CaseStatement" and
  not afterTerminating.getAPrimaryQlClass() = "DefaultStatement"
select afterTerminating, "This statement is unreachable - it follows a return, exit, or throw statement."
