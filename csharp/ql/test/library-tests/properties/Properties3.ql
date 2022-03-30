/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Caption") and
  p.isReadWrite() and
  p.isPublic() and
  p.getGetter().getAssemblyName() = "get_Caption" and
  p.getSetter().getAssemblyName() = "set_Caption"
select p, p.getGetter(), p.getSetter()
