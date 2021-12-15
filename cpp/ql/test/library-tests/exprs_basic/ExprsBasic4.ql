/**
 * @name ExprsBasic4
 * @kind table
 */

import cpp

from Field f, string fname, string ftype
where
  f.hasName(fname) and
  f.getDeclaringType().hasName(ftype) and
  exists(f.getAnAccess())
select f, fname, f.getDeclaringType(), ftype, f.getAnAccess()
