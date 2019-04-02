import javascript

from AmdModule m, Import i
where i = m.getAnImport()
select m, i, i.getImportedModule()
