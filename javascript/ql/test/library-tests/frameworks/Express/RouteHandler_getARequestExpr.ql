import semmle.javascript.frameworks.Express

from Express::RouteHandler rh
select rh, rh.getARequestExpr()
