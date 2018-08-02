import semmle.javascript.frameworks.Express

from Koa::RouteHandler rh
select rh, rh.getAResponseExpr()
