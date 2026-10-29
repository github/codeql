import swift

from LabeledStmt stmt
where stmt.getLocation().getFile().getName().matches("%swift/ql/test%")
select stmt
