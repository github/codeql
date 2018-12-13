/**
 * @name Display strings of callables
 * @kind display-string
 * @metricType callable
 * @id java/callable-display-strings
 */

import java

private string prefix(Callable c) {
  if c instanceof Constructor and c.getDeclaringType() instanceof AnonymousClass
  then result = "<anonymous constructor>"
  else result = ""
}

from Callable c
where c.fromSource()
select c, prefix(c) + c.getStringSignature()
