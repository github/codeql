/**
 * @deprecated
 * @name Duplicate function
 * @description There is another identical implementation of this function. Extract the code to a common file or superclass to improve sharing.
 * @kind problem
 * @tags testability
 *       useless-code
 *       maintainability
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/duplicate-function
 */

import python

from Function m, Function other, string message
where none()
select m, message, other, other.getName()
