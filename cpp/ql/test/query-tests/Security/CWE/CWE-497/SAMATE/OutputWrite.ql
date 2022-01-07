import semmle.code.cpp.security.OutputWrite

from OutputWrite ow
select ow, ow.getASource()
