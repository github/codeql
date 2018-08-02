import javascript

from HTTP::HeaderDefinition hd, Koa::RouteHandler rh
where rh = hd.getRouteHandler()
select hd, rh
