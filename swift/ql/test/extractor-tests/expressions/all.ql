import swift

from Expr expr
where expr.getLocation().getFile().getName().matches("%swift/ql/test%")
select expr, expr.getPrimaryQlClasses()
