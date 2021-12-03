import cpp

from Expr e, string msg, LocalVariable var, Function f
where
  e = var.getInitializer().getExpr().getFullyConverted() and
  var.getFunction() = f and
  (
    e.isConstant() and
    f.getName() = "nonConstantAddresses" and
    msg = "misclassified as constant"
    or
    not e.isConstant() and
    f.getName() = "constantAddresses" and
    msg = "misclassified as NOT constant"
  )
select e, var.getName(), msg
