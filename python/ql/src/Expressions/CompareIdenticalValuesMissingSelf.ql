/**
 * @name Maybe missing 'self' in comparison
 * @description Comparison of identical values, the intent of which is unclear.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/comparison-missing-self
 */

import python
import Expressions.RedundantComparison

from RedundantComparison comparison
where comparison.maybeMissingSelf()
select comparison, "Comparison of identical values; may be missing 'self'."
