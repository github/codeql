/**
 * @deprecated
 * @name Similar function
 * @description There is another function that is very similar this one. Extract the common code to a common function to improve sharing.
 * @kind problem
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @problem.severity recommendation
 * @sub-severity low
 * @precision very-high
 * @id py/similar-function
 */

import python

from Function m, Function other, string message
where none()
select m, message, other, other.getName()
