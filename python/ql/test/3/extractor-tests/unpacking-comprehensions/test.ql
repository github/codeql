import python

from Expr e
where
  e.getLocation().getFile().getShortName() = "test.py" and
  (
    e instanceof ListComp or
    e instanceof SetComp or
    e instanceof DictComp or
    e instanceof GeneratorExp
  )
select e.getLocation().getStartLine(), e.toString()
