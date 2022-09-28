import swift

from FuncDecl f
where f.getLocation().getFile().getBaseName() != "Package.swift"
select f
