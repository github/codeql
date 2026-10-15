import cpp

string childrenFrom(Expr e, int i) {
  (
    if i = 0
    then result = e.getChild(i).toString() + childrenFrom(e, i + 1)
    else result = "," + e.getChild(i).toString() + childrenFrom(e, i + 1)
  )
  or
  i = e.getNumChild() and result = ""
}

from Expr e, string value
where if exists(e.getValue()) then value = e.getValue().toString() else value = "<none>"
select e, childrenFrom(e, 0), value
