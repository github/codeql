import python

from BinaryExpr b
where b.getOp() instanceof MatMult
select b.getLocation().getStartLine(), b.toString()
