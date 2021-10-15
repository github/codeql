import default

string printableEnclosingStmt(Expr e) {
  result = "stmt on line " + e.getEnclosingStmt().getLocation().getStartLine()
  or
  not exists(e.getEnclosingStmt()) and result = "--none--"
}

from Expr e
where e.getFile().toString() = "A"
select e, printableEnclosingStmt(e)
