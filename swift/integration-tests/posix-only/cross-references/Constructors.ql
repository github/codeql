import swift

from ConstructorDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
