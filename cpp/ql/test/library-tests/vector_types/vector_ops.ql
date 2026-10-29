import cpp

from Operation op, GNUVectorType type
where type = op.getType()
select op, op.getOperator(), type
