import swift

from LabeledConditionalStmt s
where s.getLocation().getFile().getName().matches("%swift/ql/test%")
select s.getAPrimaryQlClass(), s.getCondition()
