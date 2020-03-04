import go

from GoModRequireLine req, GoModModuleLine mod
where req.getFile() = mod.getFile()
select req, mod.getPath(), req.getPath(), req.getVer()
