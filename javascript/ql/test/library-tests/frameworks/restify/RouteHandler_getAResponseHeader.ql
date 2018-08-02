import semmle.javascript.frameworks.Express

from Restify::RouteHandler rh, string name
select rh, name, rh.getAResponseHeader(name)
