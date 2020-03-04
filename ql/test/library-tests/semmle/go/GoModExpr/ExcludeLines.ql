import go

from GoModExcludeLine excl, GoModModuleLine mod
where excl.getFile() = mod.getFile()
select excl, mod.getPath(), excl.getPath(), excl.getVer()
