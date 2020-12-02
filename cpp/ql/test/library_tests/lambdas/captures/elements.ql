import cpp

from Element e
where
  not e instanceof BuiltInType and
  not e instanceof Specifier and
  not e instanceof Folder
select e
