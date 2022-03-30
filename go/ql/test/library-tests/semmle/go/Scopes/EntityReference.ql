import go

from Entity e, string declloc
where
  declloc = "file://" + e.getDeclaration().getLocation().toString()
  or
  not exists(e.getDeclaration()) and
  declloc = "<library>"
select e, declloc, e.getAReference()
