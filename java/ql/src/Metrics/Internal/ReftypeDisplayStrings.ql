/**
 * @name Display strings of reference types
 * @kind display-string
 * @metricType reftype
 * @id java/reference-type-display-strings
 */

import java

private string suffix(RefType t) {
  if t instanceof AnonymousClass then result = "<anonymous class>" else result = ""
}

from RefType t
where t.fromSource()
select t, t.nestedName() + suffix(t)
