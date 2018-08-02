import javascript

from HTTP::HeaderDefinition hd
where hd.getRouteHandler() instanceof Connect::RouteHandler
select hd, hd.getAHeaderName()
