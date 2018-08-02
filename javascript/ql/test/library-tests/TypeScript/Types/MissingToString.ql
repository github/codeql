import javascript

from Type typ
where not exists(typ.toString())
select "Missing toString for " + typ.getAQlClass()
