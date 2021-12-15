import cpp
import semmle.code.cpp.commons.Buffer

from Class c, MemberVariable v
where memberMayBeVarSize(c, v)
select c, v
