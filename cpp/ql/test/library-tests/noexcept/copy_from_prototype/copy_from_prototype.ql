import cpp

from Function f, string e
where
  if f.hasExceptionSpecification()
  then
    if exists(f.getADeclarationEntry().getNoExceptExpr())
    then e = f.getADeclarationEntry().getNoExceptExpr().toString()
    else e = "<no expr>"
  else e = "<none>"
select f, f.getFullSignature(), f.getDeclaringType(), e
