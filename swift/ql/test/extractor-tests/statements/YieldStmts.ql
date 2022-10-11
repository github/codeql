import swift

from YieldStmt yield, int i
where yield.getLocation().getFile().getName().matches("%swift/ql/test%")
select yield, i, yield.getResult(i)
