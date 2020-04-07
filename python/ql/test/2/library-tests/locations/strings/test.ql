import python

from StrConst s, int bl, int bc, int el, int ec
where s.getLocation().hasLocationInfo(_, bl, bc, el, ec)
select bl, bc, el, ec, s.getText()
