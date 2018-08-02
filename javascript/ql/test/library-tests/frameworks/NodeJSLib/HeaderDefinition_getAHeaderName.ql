import javascript

from HTTP::HeaderDefinition hd
where hd.getRouteHandler() instanceof NodeJSLib::RouteHandler
select hd, hd.getAHeaderName()
