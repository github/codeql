/**
 * @name Assignment to parameter
 * @description Changing a parameter's value in a method or constructor may decrease code
 *              readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/assignment-to-parameter
 * @tags maintainability
 */

import java

from Assignment a, Parameter p
where a.getDest() = p.getAnAccess()
select a, "Assignment to parameters may decrease code readability."
