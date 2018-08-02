import semmle.javascript.frameworks.Express

from Hapi::RouteHandler rh
select rh, rh.getARequestExpr()
