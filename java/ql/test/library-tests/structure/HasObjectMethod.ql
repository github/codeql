/**
 * @name HasMethod
 */

import default

from RefType inheritor, Method method, RefType declarer
where
  inheritor.hasMethod(method, declarer) and
  inheritor.fromSource() and
  declarer.hasName("Object") and
  inheritor.getFile().toString() = "Inherit"
select inheritor.toString(), method.toString(), declarer.toString()
