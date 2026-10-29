import swift

from NamedPattern p
where p.getFile().getBaseName() = "patterns.swift"
select p
