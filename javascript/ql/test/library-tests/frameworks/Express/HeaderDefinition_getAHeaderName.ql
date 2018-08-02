import javascript

from HTTP::HeaderDefinition hd
where hd.getRouteHandler() instanceof Express::RouteHandler
select hd, hd.getAHeaderName()
