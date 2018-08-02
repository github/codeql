import javascript

from TopLevel tl
where not tl.isExterns()
select tl.getFile().getBaseName()
