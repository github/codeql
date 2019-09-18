/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Caption") and
  p.isReadWrite() and
  p.isPublic()
select p, p.getGetter(), p.getSetter()
