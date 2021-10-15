/**
 * @name Unused index variable
 * @description Iterating over an array but not using the index variable to access array elements
 *              may indicate a typo or logic error.
 * @kind problem
 * @problem.severity warning
 * @id js/unused-index-variable
 * @precision high
 * @tags correctness
 */

import javascript
import UnusedIndexVariable

from RelationalComparison rel, Variable idx, Variable v
where unusedIndexVariable(rel, idx, v)
select rel, "Index variable " + idx + " is never used to access elements of " + v + "."
