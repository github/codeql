import javascript

from HTTP::HeaderDefinition hd
where hd.getRouteHandler() instanceof Koa::RouteHandler
select hd, hd.getAHeaderName()
