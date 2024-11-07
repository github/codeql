/**
 * @name Unused variable
 * @description Unused variables may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id rust/unused-variable
 * @tags maintainability
 */

import rust
import UnusedVariable

from Variable v
where isUnused(v)
select v, "Variable '" + v + "' is not used."
