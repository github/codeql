import python

from Scope s
select s.toString(), count(BasicBlock bb | bb.getScope() = s)
