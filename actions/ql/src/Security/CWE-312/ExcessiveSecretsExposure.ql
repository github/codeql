/**
 * @name Excessive Secrets Exposure
 * @description All organization and repository secrets are passed to the workflow runner.
 * @kind problem
 * @problem.severity recommendation
 * @id actions/excessive-secrets-exposure
 * @tags actions
 *       security
 *       external/cwe/cwe-312
 */

import actions
import codeql.actions.ast.internal.Ast

from Expression expr
where
  getAToJsonReferenceExpression(expr.getExpression(), _).matches("secrets%")
  or
  expr.getExpression().matches("secrets[%") and
  not expr.getExpression().matches("secrets[\"%") and
  not expr.getExpression().matches("secrets['%")
select expr, "All organization and repository secrets are passed to the workflow runner in $@",
  expr, expr.getExpression()
