import javascript

from PropertyPattern pp, string name
where (if exists(pp.getName()) then name = pp.getName() else name = "<unknown>")
select pp, name
