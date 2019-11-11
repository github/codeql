/**
 * @name Self comparison
 * @description Comparing a variable to itself always produces the
 *              same result, unless the purpose is to check for
 *              integer overflow or floating point NaN.
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
where
  pointlessSelfComparison(cmp) and
  not nanTest(cmp) and
  not overflowTest(cmp) and
  not cmp.isFromTemplateInstantiation(_) and
  not exists(MacroInvocation mi |
    // cmp is in mi
    mi.getAnExpandedElement() = cmp and
    // and cmp was apparently not passed in as a macro parameter
    cmp.getLocation().getStartLine() = mi.getLocation().getStartLine() and
    cmp.getLocation().getStartColumn() = mi.getLocation().getStartColumn()
  )
select cmp, "Self comparison."
