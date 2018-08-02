import semmle.javascript.frameworks.Express

from Koa::RouteHandler rh, string name
select rh, name, rh.getAResponseHeader(name)
