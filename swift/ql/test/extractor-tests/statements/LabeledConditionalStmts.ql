import swift

from LabeledConditionalStmt s
where s.getLocation().getFile().getName().contains("swift/ql/test")
select s.getAPrimaryQlClass(), s.getCondition()
