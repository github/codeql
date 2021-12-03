import csharp

from Assignment a
select a.getLocation(), a.getLValue().getType().toString(), a.getRValue().getType().toString(),
  a.getRValue().toString()
