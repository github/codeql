import default

from Literal l
where exists(l.getFile().getRelativePath())
select l
