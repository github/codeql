import javascript

from Module m, string name, DataFlow::Node exportValue
where exportValue = m.getAnExportedValue(name)
select m, name, exportValue
