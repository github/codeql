import java

from RefType t
where t = t.getAStrictAncestor()
select t.toString()
