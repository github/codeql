/**
 * @name StringAnalysis
 * @kind table
 */

import cpp

from AnalysedString s, string str
where
  if s.(StringLiteral).getUnspecifiedType().(DerivedType).getBaseType() instanceof Wchar_t
  then str = "[?]"
  else str = s.toString()
select s.getLocation().toString(), str, s.getMaxLength()
