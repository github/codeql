/**
 * @name Hidden pointer indirection
 * @description Pointer indirection may not be hidden by typedefs -- "typedef int* IntPtr;" is not allowed.
 * @kind problem
 * @id cpp/power-of-10/hidden-pointer-indirection
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/powerof10
 */

import cpp

from TypedefType t
where t.getBaseType().getPointerIndirectionLevel() > 0
select t, "The typedef " + t.getName() + " hides pointer indirection."
