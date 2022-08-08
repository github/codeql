import swift

from StructDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
