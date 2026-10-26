import cpp

from FunctionDeclarationEntry func, CallingConventionSpecifier ccs
where ccs.hasName(func.getASpecifier())
select func, func.getASpecifier()
