import java

from AssignOp ae
select ae, ae.getOp(), ae.getType().toString(), ae.getDest(), ae.getDest().getType().toString(),
  ae.getRhs(), ae.getRhs().getType().toString()
