import semmle.javascript.frameworks.Express

from Expr nd
where Express::isResponse(nd)
select nd