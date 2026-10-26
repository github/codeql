/**
 * @name Implicit import
 * @description An implicit import obscures the dependencies of a file and may cause confusing
 *              compile-time errors.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/implicit-import
 * @tags maintainability
 */

import java

from ImportOnDemandFromPackage i
select i, "It is advisable to make imports explicit."
