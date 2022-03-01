import csharp

from Assignment a
where a.fromSource()
select a.getLocation(), a.getLValue().getType().toString(), a.getRValue().getType().toString(),
  a.getRValue().toString()
