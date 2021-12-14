/**
 * @name Hidden pointer indirection
 * @description Pointer indirection may not be hidden by typedefs -- "typedef int* IntPtr;" is not allowed.
 * @kind problem
 * @id cpp/jpl-c/hidden-pointer-indirection-typedef
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from TypedefType t
where t.getBaseType().getPointerIndirectionLevel() > 0
select t, "The typedef " + t.getName() + " hides pointer indirection."
