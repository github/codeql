
import python

string longname(Expr e) {
    result = e.(Name).getId()
    or
    exists(Attribute a |
        a = e |
        result = longname(a.getObject()) + "." + a.getName()
    )
}

from Expr e, Object o
where e.refersTo(o) and e.getLocation().getFile().getShortName() = "test.py"
select longname(e), o.toString()

