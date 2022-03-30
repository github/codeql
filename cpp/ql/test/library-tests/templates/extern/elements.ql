import cpp

from Element e
where
  exists(e.getLocation()) and
  not e.getLocation() instanceof UnknownLocation and
  not e instanceof Folder
select e
