import cpp

from Expr e
select e, count(e.getAPredecessor()), count(e.getASuccessor())
