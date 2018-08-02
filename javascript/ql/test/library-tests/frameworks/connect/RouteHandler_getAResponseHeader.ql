import semmle.javascript.frameworks.Express

from Connect::RouteHandler rh, string name
select rh, name, rh.getAResponseHeader(name)
