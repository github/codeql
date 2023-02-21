import swift

string describe(Expr e) {
  e instanceof Assignment and result = "Assignment"
  or
  e instanceof AssignOperation and result = "AssignOperation"
  or
  e instanceof AssignArithmeticOperation and result = "AssignArithmeticOperation"
  or
  e instanceof AssignBitwiseOperation and result = "AssignBitwiseOperation"
  or
  e instanceof AssignExpr and result = "AssignExpr"
  or
  e instanceof AssignAddExpr and result = "AssignAddExpr"
  or
  e instanceof AssignLShiftExpr and result = "AssignLShiftExpr"
}

from Assignment e
where
  e.getLocation().getFile().getBaseName() != ""
select
  e,
  concat(describe(e), ", "),
  concat(e.getDest().toString(), ", "),
  concat(e.getSource().toString(), ", ")
