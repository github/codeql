/**
 * @name SystemCall
 * @description Test the definition of System Get Property
 */

import default

from MethodAccessSystemGetProperty ma
where ma.hasCompileTimeConstantGetPropertyName("user.dir")
select ma
