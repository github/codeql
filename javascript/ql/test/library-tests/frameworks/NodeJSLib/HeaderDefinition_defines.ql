import javascript

from HTTP::HeaderDefinition hd, string name, string value
where hd.defines(name, value) and
      hd.getRouteHandler() instanceof NodeJSLib::RouteHandler
select hd, name, value
