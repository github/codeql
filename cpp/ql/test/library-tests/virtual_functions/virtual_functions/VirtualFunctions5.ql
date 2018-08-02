/**
 * @name VirtualFunctions5
 * @description Test of getAnOverridingFunction in a hierarchy with no virtual inheritance
 * @kind table
 */

import cpp

from VirtualFunction f
where
	f.getDeclaringType().getName().matches("X%")
select f.getDeclaringType(), f.getAnOverridingFunction().getDeclaringType()