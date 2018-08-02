import javascript

from HTTP::HeaderDefinition hd
where hd.getRouteHandler() instanceof Restify::RouteHandler
select hd, hd.getAHeaderName()
