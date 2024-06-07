import swift

from Deinitializer d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
