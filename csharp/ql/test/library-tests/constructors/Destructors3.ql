/**
 * @name Test for destructors
 */

import csharp

from Destructor d, ValueOrRefType t
where
  t = d.getDeclaringType() and
  not t instanceof ConstructedGeneric and
  not t instanceof UnboundGenericType and
  d.getName() != "~" + t.getName()
select t, d
