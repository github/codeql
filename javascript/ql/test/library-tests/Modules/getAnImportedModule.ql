import javascript

from Module mod
select mod.getFile().getRelativePath(), mod.getAnImportedModule().getFile().getRelativePath()
