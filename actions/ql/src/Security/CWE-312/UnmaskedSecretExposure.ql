/**
 * @name Unmasked Secret Exposure
 * @description Secrets derived from other secrets are not masked by the workflow runner.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id actions/unmasked-secret-exposure
 * @tags actions
 *       security
 *       external/cwe/cwe-312
 */

import actions

from Expression expr
where expr.getExpression().regexpMatch("(?i).*fromjson\\(secrets\\..*\\)\\..*")
select expr, "An unmasked secret derived from another secret may be exposed in $@", expr,
  expr.getExpression()
