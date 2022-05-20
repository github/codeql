import cpp

Function getCfgFunction(Initializer i) { result = i.getASuccessor*() }

from Initializer i, string f
where if exists(getCfgFunction(i)) then f = getCfgFunction(i).toString() else f = ""
select i, f
