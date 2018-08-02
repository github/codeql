import cpp

from Element e
where not e.getLocation() instanceof UnknownLocation
  and not e instanceof Folder
select e
