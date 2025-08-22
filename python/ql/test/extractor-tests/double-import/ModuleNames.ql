import python

from Container path, string name
where exists(ModuleValue m | m.getPath() = path and m.getName() = name)
select path, name
