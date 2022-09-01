import swift

from EnumDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
