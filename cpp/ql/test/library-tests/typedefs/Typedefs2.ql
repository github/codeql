import cpp

from Function f1, Block body, Declaration d
where
  body = f1.getBlock() and
  d = body.getADeclaration()
select f1, d, concat(d.getAQlClass(), ", ")
