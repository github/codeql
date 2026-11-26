import codeql.swift.elements

from Pattern p
where p.getLocation().getFile().getName().contains("swift/ql/test")
select p
