import javascript

from HTTP::HeaderDefinition hd
where hd.getRouteHandler() instanceof Hapi::RouteHandler
select hd, hd.getAHeaderName()
