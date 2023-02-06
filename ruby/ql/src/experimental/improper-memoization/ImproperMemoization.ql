/**
 * @name Improper Memoization
 * @description Omitting a parameter from the key of a memoization method can lead to reading stale or incorrect data.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       experimental
 * @id rb/improper-memoization
 */

import codeql.ruby.AST
import codeql.ruby.security.ImproperMemoizationQuery

from Method m, Parameter p, AssignLogicalOrExpr s
where isImproperMemoizationMethod(m, p, s)
select m, "A $@ in this memoization method does not form part of the memoization key.", p,
  "parameter"
