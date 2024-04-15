import python

from AstNode a, int bl, int bc, int el, int ec
where a.getLocation().hasLocationInfo(_, bl, bc, el, ec)
select bl, bc, el, ec, a.toString()
