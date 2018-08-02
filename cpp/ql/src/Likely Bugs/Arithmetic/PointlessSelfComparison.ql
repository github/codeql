/**
 * @name Self comparison
 * @description Comparing a variable to itself always produces the
                same result, unless the purpose is to check for
                integer overflow or floating point NaN.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/comparison-of-identical-expressions
 * @tags readability
 *       maintainability
 */

import cpp
import PointlessSelfComparison

from ComparisonOperation cmp
where pointlessSelfComparison(cmp)
  and not nanTest(cmp)
  and not overflowTest(cmp)
select cmp, "Self comparison."
