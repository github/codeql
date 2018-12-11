/**
 * @name Comparison of identical values
 * @description Comparison of identical values, the intent of which is unclear.
 * @kind problem
 * @tags reliability
 *       correctness
 *       readability
 *       convention
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/comparison-of-identical-expressions
 */

import python
import Expressions.RedundantComparison

from RedundantComparison comparison
where not comparison.isConstant() and not comparison.maybeMissingSelf()
select comparison, "Comparison of identical values; use cmath.isnan() if testing for not-a-number."
