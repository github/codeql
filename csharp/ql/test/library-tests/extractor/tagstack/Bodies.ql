import csharp

from Method m
where strictcount(m.getBody()) > 1
select m, "This method has multiple bodies."
