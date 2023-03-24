import cpp

from Element e
where
  e.getLocation().getFile().getBaseName() != "" and
  not e instanceof Container
select e
