import python

from Container f
where exists(Module m | m.getPath() = f)
select f.toString()
