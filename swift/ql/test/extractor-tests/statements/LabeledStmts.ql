import swift

from LabeledStmt stmt
where stmt.getLocation().getFile().getName().contains("swift/ql/test")
select stmt
