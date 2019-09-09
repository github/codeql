import semmle.code.cpp.PODType03

from Class c, boolean ispod
where if isPODClass03(c) then ispod = true else ispod = false
select c, ispod
