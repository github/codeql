/**
 * @name Annotations
 * @description Check that annotation ids are distinct
 */

import default

private
int numberOfLocations(Annotation a) {
  result = count(a.getLocation())
}

from Annotation a, RefType c, Location loc
where c.hasQualifiedName("annotations", "C")
  and c.getAnAnnotation() = a.getParent*()
  and loc = a.getLocation()
select loc.getStartLine(), loc.getStartColumn(), a, numberOfLocations(a)
