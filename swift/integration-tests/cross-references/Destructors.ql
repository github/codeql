import swift

from DestructorDecl d
where d.getLocation().getFile().getBaseName() != "Package.swift"
select d
