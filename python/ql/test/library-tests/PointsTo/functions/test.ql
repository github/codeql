import python

from Call c, FunctionObject f
where
  c.getFunc().(Attribute).getObject().(Name).getId() = "self" and
  f.getACall().getNode() = c
select c.getLocation().getStartLine(), f.toString()
