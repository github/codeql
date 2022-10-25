import swift

from OperatorDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
