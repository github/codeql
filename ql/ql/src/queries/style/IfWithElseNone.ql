/**
 * @name Use of 'if' with a 'none()' branch.
 * @description Using 'if p() then q() else none()' is bad style. It should be rewritten as 'p() and q()'.
 * @kind problem
 * @problem.severity warning
 * @id ql/if-with-none
 * @precision very-high
 * @tags maintainability
 */

import ql

from IfFormula ifFormula
where ifFormula.getElsePart() instanceof NoneCall or ifFormula.getThenPart() instanceof NoneCall
select ifFormula, "Use a conjunction instead."
