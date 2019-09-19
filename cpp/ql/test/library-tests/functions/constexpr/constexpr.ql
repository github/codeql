import cpp
import semmle.code.cpp.Print

from Function f
select f, getIdentityString(f),
  any(boolean b | if f.isDeclaredConstexpr() then b = true else b = false),
  any(boolean b | if f.isConstexpr() then b = true else b = false)
