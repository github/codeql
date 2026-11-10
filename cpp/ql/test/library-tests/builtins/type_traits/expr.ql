import cpp

from Expr e, string value
where if exists(e.getValue()) then value = e.getValue().toString() else value = "<none>"
select e, concat(int i | | e.getChild(i).toString(), "," order by i), value
