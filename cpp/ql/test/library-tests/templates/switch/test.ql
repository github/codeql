import cpp

from SwitchStmt ss
select ss, count(SwitchCase sc | ss = sc.getSwitchStmt())
