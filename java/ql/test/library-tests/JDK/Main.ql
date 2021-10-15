/**
 * @name Main
 * @description Test the definition of class MainMethod
 */

import default

from Class cl, MainMethod mm
where cl.fromSource() and mm = cl.getAMember()
select cl, mm
