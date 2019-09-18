/**
 * @name HasMethod
 */

import default

from RefType inheritor, Method method, RefType declarer
where inheritor.hasMethod(method, declarer) and method.fromSource()
select inheritor, method, declarer
