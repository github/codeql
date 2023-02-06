import codeql.swift.elements

from Pattern p
where p.getLocation().getFile().getName().matches("%swift/ql/test%")
select p
