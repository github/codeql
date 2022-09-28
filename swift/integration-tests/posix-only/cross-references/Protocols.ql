import swift

from ProtocolDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
