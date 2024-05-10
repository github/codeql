import relevant

from Function fn, StaticLocalVariable var, ReturnStmt ret, string path
where ret.getExpr() = var.getAnAccess()
 and var.getFunction() = fn
 and path = fn.getFile().getRelativePath()
select fn, "This function returns a static local variable"
