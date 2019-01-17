import python


string loc(AstNode a) {
    exists(Location l |
        l = a.getLocation() |
        result = l.getFile().getBaseName() + ":" + l.getStartLine() + ":" + l.getStartColumn()
    )
}

from AstNode p, AstNode c
where p.getAChildNode() = c
select loc(p), p.toString(), loc(c), c.toString()

