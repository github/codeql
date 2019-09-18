/**
 * @name Test for destructors
 */

import csharp

where forex(Type t | count(Destructor d | d.getDeclaringType() = t) <= 1)
select 1
