import javascript

from string path, string prop
select path, prop, DataFlow::moduleImport(path).getAPropertyRead(prop)
