import codeql.swift.elements

from Pattern p
where exists(p.getLocation())
select p
