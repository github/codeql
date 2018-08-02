import semmle.javascript.frameworks.Express

from Restify::RouteHandler rh
select rh, rh.getAResponseExpr()
