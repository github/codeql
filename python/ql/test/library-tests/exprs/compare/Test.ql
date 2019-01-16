
import python

string loc(AstNode f) {
    exists(Location l |
        l = f.getLocation() |
        result = l.getFile().getBaseName() + ":" + l.getStartLine() + ":" + l.getStartColumn()
    )
}

from Compare comp, Expr left, Expr right, Cmpop op
where comp.compares(left, op, right)
select loc(comp), comp.toString(), left.toString(), op.toString(), right.toString()
