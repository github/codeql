import codeql.lua.SourceFile

from LuaSourceFile file
where file.getBaseName() in ["alpha.lua", "settings.lua", "worker.lua"]
select file.getBaseName(), file.getLineCount(), file.getByteCount(), file.getSha256()
