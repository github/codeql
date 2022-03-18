/**
 * @name Dead code
 * @description Code that cannot be reached should be deleted.
 * @kind problem
 * @problem.severity warning
 * @id ql/dead-code
 * @precision very-high
 */

import ql
import codeql_ql.style.DeadCodeQuery

from AstNode node
where isDead(node)
select node, "Code is dead"
