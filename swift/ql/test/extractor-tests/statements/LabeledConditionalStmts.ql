import swift

from LabeledConditionalStmt s
where exists(s.getLocation())
select s.getAPrimaryQlClass(), s.getCondition()
