import semmle.code.cpp.PODType03

from Class c, boolean ispod
where if isPodClass03(c) then ispod = true else ispod = false
select c, ispod
