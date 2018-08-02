/**
 * @name VirtualFunctions6
 * @description Test of getAnOverridingFunction in a hierarchy with virtual inheritance
 * @kind table
 */

import cpp

from VirtualFunction f
where
	f.getDeclaringType().getName().matches("Y%")
select f.getDeclaringType(), f.getAnOverridingFunction().getDeclaringType()