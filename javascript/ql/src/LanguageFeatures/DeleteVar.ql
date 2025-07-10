/**
 * @name Deleting non-property
 * @description The operand of the 'delete' operator should always be a property accessor.
 * @kind problem
 * @problem.severity warning
 * @id js/deletion-of-non-property
 * @tags reliability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-480
 * @precision very-high
 */

import javascript

from DeleteExpr del
where not del.getOperand().stripParens() instanceof PropAccess
select del, "Only properties should be deleted."
