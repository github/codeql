import semmle.javascript.frameworks.Express

from Expr nd
where Express::isRequest(nd)
select nd
