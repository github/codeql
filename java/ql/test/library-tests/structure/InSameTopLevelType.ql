/**
 * @name InSameTopLevelType
 */

import default

from Element e, Element f
where
  exists(TopLevelType t | t.hasChildElement*(e) and t.hasChildElement*(f)) and
  e.fromSource() and
  f.fromSource() and
  e.getName() < f.getName() and
  e.getFile().toString() = "A"
select e, f
