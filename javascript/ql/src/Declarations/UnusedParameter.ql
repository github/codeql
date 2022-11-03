/**
 * @name Unused parameter
 * @description Unused parameters make functions hard to read and hard to use, and should be removed.
 * @kind problem
 * @problem.severity recommendation
 * @id js/unused-parameter
 * @tags maintainability
 * @precision medium
 */

import javascript
import UnusedParameter

from Parameter p
where isAnAccidentallyUnusedParameter(p)
select p, "Unused parameter " + p.getAVariable().getName() + "."
