import swift

from VarDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
