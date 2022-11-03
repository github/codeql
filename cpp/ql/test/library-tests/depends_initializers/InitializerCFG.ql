import cpp

Function getCFGFunction(Initializer i) { result = i.getASuccessor*() }

from Initializer i, string f
where if exists(getCFGFunction(i)) then f = getCFGFunction(i).toString() else f = ""
select i, f
