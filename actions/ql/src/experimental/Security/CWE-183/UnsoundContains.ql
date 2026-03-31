/**
 * @name Unsound use of contains() for membership check
 * @description Using `contains()` with a string literal as the first argument performs a substring
 *              match instead of an array membership check, which can be bypassed.
 * @kind problem
 * @precision high
 * @security-severity 5.0
 * @problem.severity warning
 * @id actions/unsound-contains
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-183
 */

import actions

/**
 * Holds if `expr` is an expression within an `if:` condition that uses `contains()`
 * with a string literal as the first argument, performing a substring match
 * instead of an array membership check.
 */
predicate isUnsoundContains(Expression expr) {
  exists(If ifNode |
    ifNode.getConditionExpr() = expr and
    // Match contains() with a string-literal first argument
    // This catches: contains('refs/heads/main refs/heads/develop', github.ref)
    // But NOT: contains(fromJSON('["refs/heads/main"]'), github.ref)
    // And NOT: contains(github.event.issue.labels.*.name, 'bug')
    (
      expr.getExpression().regexpMatch("(?i)contains\\s*\\(\\s*'[^']*'\\s*,.*")
      or
      expr.getExpression().regexpMatch("(?i)contains\\s*\\(\\s*\"[^\"]*\"\\s*,.*")
    )
  )
}

from Expression expr
where isUnsoundContains(expr)
select expr,
  "The `contains()` call performs a substring match which can be bypassed. Use `fromJSON()` to create an array for a proper membership check."
