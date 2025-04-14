import swift

from ClassDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
