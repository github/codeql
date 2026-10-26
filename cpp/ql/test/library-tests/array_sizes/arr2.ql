import cpp

from ArrayType at, string sz
where if exists(at.getArraySize()) then sz = at.getArraySize().toString() else sz = ""
select at, sz
