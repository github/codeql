import python

string async(Function f) { if f.isAsync() then result = "yes" else result = "no" }

from Function f
select f, async(f)
