import cpp

from ExprCall c, PointerDereferenceExpr deref, VariableAccess va,
     Access fnacc
where c.getLocation().getFile().getBaseName() = "cjpeg.c" and
      c.getLocation().getStartLine() = 640 and
      deref = c.getExpr() and
      va = deref.getOperand() and
      fnacc = va.getTarget().getAnAssignedValue()
select c, fnacc.getTarget()