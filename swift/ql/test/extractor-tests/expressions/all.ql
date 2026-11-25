import swift

from Expr expr
where expr.getLocation().getFile().getName().contains("swift/ql/test")
select expr, expr.getPrimaryQlClasses()
