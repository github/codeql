import swift

from LabeledStmt stmt
where exists(stmt.getLocation())
select stmt, stmt.getLabel()
