import cpp
import semmle.code.cpp.Print

from Function f, string e
where
  if f.hasExceptionSpecification()
  then
    if exists(f.getADeclarationEntry().getNoExceptExpr())
    then e = f.getADeclarationEntry().getNoExceptExpr().toString()
    else e = "<no expr>"
  else e = "<none>"
select f, getIdentityString(f), f.getDeclaringType(), e
