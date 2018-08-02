import semmle.javascript.frameworks.Express

from Connect::RouteHandler rh
select rh, rh.getARequestExpr()
