import semmle.javascript.frameworks.Express

from NodeJSLib::RouteHandler rh, string name
select rh, name, rh.getAResponseHeader(name)
