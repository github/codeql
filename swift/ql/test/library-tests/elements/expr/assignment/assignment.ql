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
  e instanceof AssignSubExpr and result = "AssignSubExpr"
  or
  e instanceof AssignMulExpr and result = "AssignMulExpr"
  or
  e instanceof AssignDivExpr and result = "AssignDivExpr"
  or
  e instanceof AssignRemExpr and result = "AssignRemExpr"
  or
  e instanceof AssignLShiftExpr and result = "AssignLShiftExpr"
  or
  e instanceof AssignRShiftExpr and result = "AssignRShiftExpr"
  or
  e instanceof AssignAndExpr and result = "AssignAndExpr"
  or
  e instanceof AssignOrExpr and result = "AssignOrExpr"
  or
  e instanceof AssignXorExpr and result = "AssignXorExpr"
  or
  e instanceof AssignPointwiseAndExpr and result = "AssignPointwiseAndExpr"
  or
  e instanceof AssignPointwiseOrExpr and result = "AssignPointwiseOrExpr"
  or
  e instanceof AssignPointwiseXorExpr and result = "AssignPointwiseXorExpr"
  or
  e.(Assignment).hasOverflowOperator() and result = "hasOverflowOperator"
}

from Assignment e
where e.getLocation().getFile().getBaseName() != ""
select e, concat(describe(e), ", "), concat(e.getDest().toString(), ", "),
  concat(e.getSource().toString(), ", ")
