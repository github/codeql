import swift

string describe(Expr e) {
  e instanceof AssignExpr and result = "AssignExpr"
}

from AssignExpr e
where
  e.getLocation().getFile().getBaseName() != ""
select
  e,
  concat(describe(e), ", "),
  concat(e.getDest().toString(), ", "),
  concat(e.getSource().toString(), ", ")
